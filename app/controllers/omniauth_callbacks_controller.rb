class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all()
    @user.terms = session[:registration_terms] == "1" if session[:registration_terms].present?
      
    add_user_to_event(@user)

    if @user.persisted?
      login_previous_user()
    elsif @current_event.live? and @current_event.can_register?
      login_new_user()
    else #event is not live or can't register and user is not in the database
      failed_login()
    end
  end
  
  def login_previous_user()
    record_event(GaEvent.new(category: :login_process, action: :sign_in, label: params[:action]))
    set_flash_message(:notice, :signed_in)
    sign_in_and_redirect @user
  end
  
  def login_new_user()
    record_event(GaEvent.new(category: :login_process, action: :register, label: params[:action]))
    session["devise.user_attributes"] = @user.attributes
    @user.skip_confirmation! if defined? @user.skip_confirmation!
    if (@user.save)
      set_flash_message(:notice, :signed_in)
      sign_in_and_redirect @user
    else
      redirect_to new_user_registration_url
    end
  end
  
  def failed_login()
    set_flash_message(:error, :sign_in_failure_cant_register)
    @user = nil
    redirect_to root_path
  end
  
  def resolve_user_email(email)
    if !email.present?
    elsif !@user.persisted? 
      user = User.find_by(email: email)
      if user.present?
        @user = user
      else
        @user.email = email
      end
    else 
      @user.email = email
    end
    @user
  end
  
  def resolve_position(position, company = nil)
    if position.present?
      positionSplit = position.split(" at ")
      if (positionSplit.size == 2 and !company.present?)
        @user.position = "#{positionSplit[0][0..255]}"
        @user.company = "#{positionSplit[1][0..255]}"
      else 
        @user.position = "#{position[0..255]}"
        @user.company = company.present? ? company[0..255] : nil
      end
    end
  end
  
  def linkedin
    get_user
    authInfo = get_auth_info
    
    resolve_user_email("#{authInfo[:info][:email]}")
    resolve_position("#{authInfo[:info][:description]}")

    @user.first_name = "#{authInfo[:info][:first_name]}"
    @user.last_name = "#{authInfo[:info][:last_name]}"
    @user.external_avatar_url = "#{authInfo[:info][:image]}"
    if extra = authInfo[:extra] and raw_info = extra[:raw_info]
      @user.industry = "#{raw_info[:industry]}"
    end
    
    all()
  end

  def facebook
    get_user
    authInfo = get_auth_info
    
    resolve_user_email(authInfo[:info][:email])
    resolve_position("#{session[:registration_position]}", "#{session[:registration_company]}")
    
    @user.first_name = authInfo[:info][:first_name]
    @user.last_name = authInfo[:info][:last_name]
    @user.external_avatar_url = authInfo[:info][:image]

    all()
  end
  
  def get_user()
    @user = User.from_omniauth(get_auth_info)
  end
  
  def get_auth_info
    request.env["omniauth.auth"]
  end
  
  def after_sign_in_path_for resource
    get_post_login_path
  end
  def set_context_objects
  end
end
