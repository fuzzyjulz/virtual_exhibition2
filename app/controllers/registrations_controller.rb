class RegistrationsController < Devise::RegistrationsController
  layout :layout_by_resource
  prepend_before_filter :require_no_authentication, :only => [ :new, :create, :cancel]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  before_filter :set_host

  helper_method :locations
  
  def visitor_actions
    ["new"]
  end
  
  # GET /resource/sign_up
  def new
    if !(@current_event.present? and @current_event.live?) or @current_event.public_scope?
      UtmCampaign.create_campaign(session, request, params)
      redirect_to "/"
      return
    end
    
    build_resource({})
    self.resource.build_uploaded_file
    if session[:popup] == true
      render action: "new_popup", layout: "modal_box"
    else
      respond_with self.resource
    end
  end

  # POST /resource
  def create
    params = sign_up_params
    build_resource(params)
    
    if (resource.provider.present?)
      @user.skip_confirmation! if defined? @user.skip_confirmation!
    end
    
    if resource.save
      yield resource if block_given?
      
      record_create_user(@user)

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        sign_in resource_name, resource, :bypass => true if (resource.provider.present?)
      end
      respond_with resource, :location => after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def record_create_user(user)
    add_user_to_event(user)
    record_event(GaEvent.new(category: :login_process, action: :register, label: :direct, user: user))
  end
  
  # GET /resource/edit
  def edit
    self.resource.build_uploaded_file unless self.resource.uploaded_file
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
      yield resource if block_given?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def social_register
    currParams = sign_up_params
    session[:registration_terms] = currParams[:terms]
    session[:registration_company] = currParams[:company]
    session[:registration_position] = currParams[:position]
    provider = params[:user][:provider] if ["linkedin", "facebook"].include?(params[:user][:provider])
      
    redirect_to omniauth_authorize_path("user", provider.to_sym, state: form_authenticity_token)
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_flashing_format?
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  def locations()
    return User::LOCATIONS.invert
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  def after_sign_in_path_for(resource)
    get_post_login_path
  end
  
  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    params = devise_parameter_sanitizer.sanitize(:sign_up)
    params["interested_topic"] = params["interested_topic"].keep_if{|v| v =~ /.+/}.join(",") unless params["interested_topic"].nil?
    return params
  end

  def account_update_params
    devise_parameter_sanitizer.sanitize(:account_update)
  end

  def set_host
    eventId = get_event_id()
    params[:id] = eventId unless eventId.nil?
    
    if request.host.include?  "govciosummit"
      @industry_collection = ["Local Government", "State Government", "Federal Government", "Private"]
    elsif request.host.include?  "educateit"
      @industry_collection = ["Primary School", "Secondary School", "Tafe", "University", "Online Learning", "College", "Other"]
    elsif request.host.include? "gtrknowledgeseries"
      @industry_collection = ["Local Government", 
                              "State Government", 
                              "Federal Government", 
                              "Primary or Secondary Education",
                              "Tertiary Education",
                              "Not-for-profit",
                              "Private Sector"]
      @interested_topics_collection = [ "Cloud Services and Infrastructure", 
                                        "Data and Information Management", 
                                        "Mobility", 
                                        "Privacy and Security",
                                        "Broadband and Communications",
                                        "e-Government"]
      elsif request.host.include? "energysummit"
        @industry_collection = ["Consulting",
                                "Energy Efficiency",
                                "Energy Storage",
                                "Finance/Investment",
                                "Gas",
                                "Government",
                                "Installation",
                                "Manufacturing",
                                "Solar",
                                "Wind",
                                "Other"]
        @interested_topics_collection = [ "Energy Efficiency",
                                          "Energy Storage",
                                          "Gas",
                                          "Government Policy",
                                          "Investment",
                                          "Solar",
                                          "Technology Innovation",
                                          "Wind",
                                          "Other"]
    end
  end

  def set_context_objects
  end
end