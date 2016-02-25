module SignInRegistrationHelper
  def on_sign_in_register_page?()
    (request.fullpath.starts_with?("/users/sign_in") or
      request.fullpath.starts_with?("/users/sign_up") or
      request.fullpath.starts_with?("/users/confirmation"))
  end

  def add_user_to_event(user)
    event = @current_event
    if (user.is_visitor? and event.present? and !user.events.include?(event))
      record_event(GaEvent.new(category: :login_process, action: :add_to_event, label: event.name, user: user))
      user.events << event
    end
  end
  
  def sign_up_modal_hash(options = {})
    {href: user_session_path({popup: true}.merge(options)), modalSizeFunction: "loginPopupSize"}
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :title, :state, :position, :work_phone, :company, :industry, {interested_topic: []}, :event_ids, :mobile, :origin, :terms]
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email) }
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation, :current_password,
        :title, :first_name, :last_name, :position, :work_phone, :mobile, :company, :state, :industry,
        :uploaded_file, :origin, :terms, { uploaded_file_attributes: [:assets, :id]} )
    end
    # Only add some parameters
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name]
    # Override accepted parameters
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:first_name, :last_name, :password, :password_confirmation,
               :invitation_token)
    end
  end
end