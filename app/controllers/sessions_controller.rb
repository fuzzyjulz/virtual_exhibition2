class SessionsController < Devise::SessionsController
  include ShoppingCartHelper 

  layout :layout_by_resource
  before_filter :set_host
  

  def visitor_actions
    ["new"]
  end

  def new
    session[:popup] = false
    session[:popup] = (params["popup"] == "true")
    if session[:popup] == true
      new_popup
    else
      if (!params[:authenticity_token].present? and @current_event.present? and @current_event.public_scope?)
        #Direct access to the sign in page on a public event
        UtmCampaign.create_campaign(session, request, params)
        redirect_to "/"
        return
      end
      super
    end
  end

  def new_popup
    if params[:popup_type] == "deals"
      @popup_type = :deals
      @active_tab = :register
    else
      @active_tab = :sign_in
    end
    
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    render action: "new_popup", layout: "modal_box"
  end
  
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)

    record_event(GaEvent.new(category: :login_process, action: :sign_in, label: :direct))
    add_user_to_event(@user)
    
    if !session[:return_to].blank?
      redirect_to session[:return_to]
      session[:return_to] = nil
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end
  
  def destroy
    super
    set_cart(nil)
  end

  def set_host
    eventId = get_event_id()
    params[:id] = eventId unless eventId.nil?
  end

  def after_sign_out_path_for(resource)
    after_sign_in_path_for resource
  end
  
  def after_sign_in_path_for resource
    get_post_login_path
  end

  def set_context_objects
  end
end
