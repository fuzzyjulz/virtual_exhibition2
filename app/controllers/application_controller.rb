class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ContextExtraction
  include BusinessLogicHelper
  include Analytics
  include MenuCreation
  include PaperclipHelper
  include StringHelper
  include UiHelper
  include SignInRegistrationHelper
  include JobHelper
  
  CRUD_ACTIONS = [:index, :show, :new, :create, :edit, :update, :destroy]
  VISITOR_ACTIONS = ["visit"]
  
  layout :layout_by_resource
  protect_from_forgery with: :exception
  before_filter :store_location
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :hide_sidebar, :set_mailer_host
  before_action :sidebar_menu, only: CRUD_ACTIONS
  before_action :redirect_to_event_home, if: Proc.new {(!@current_user.present? or @current_user.is_visitor?) and @current_event != get_event}
  
  #String Helper Methods
  helper_method :safe_chars, :no_html

  helper_method :sign_up_modal_hash, :on_sign_in_register_page?, :on_visitor_page?
  helper_method :available_booths, :available_halls, :available_events
  helper_method :link_tag_gz, :client_is_ie?, :event_landing_path
  helper_method :resource
  
  def not_live_event
    event = @event
    event ||= @current_event if @current_event.present?
    if event.nil? or !can?(:_basic_admin, event)
      respond_to do |format|
        format.html {redirect_to "/"}
      end
    end
  end
  
  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
  protected
  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (!request.fullpath.start_with?("/users") &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end
  
  def event_landing_path(event)
    return "/" if event.landing_hall.nil?
    hall_visit_path(event.landing_hall)
  end

  def redirect_to_event_home
    @current_event = get_event
    session[:previous_url] = nil
    redirect_to get_post_login_path
  end
  
  def get_post_login_path
    UtmCampaign.create_campaign(session, request, params)

    if current_user.present? and current_user.has_role?(:booth_rep)
      return root_path
    end
    
    return session[:previous_url] if session[:previous_url]
    
    if @current_event.present? and @current_event.live?
      event_landing_path(@current_event)
    else
      root_path
    end
  end
  
  def layout_by_resource
    "users"
  end
  
  def visitor_actions
    VISITOR_ACTIONS
  end
  
  def on_visitor_page?
    visitor_actions.include?(action_name)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  
  #Used for controller messages using responder 
  def interpolation_options
    { resource_errors: "#{resource.errors.full_messages.to_s.gsub(/[\[\]\"]/,"")}" }
  end
  def resource_name
    controller_name[0,controller_name.size - 1]
  end
  def resource
    instance_variable_get(:"@#{resource_name}")
  end

  def available_booth_or_hall(objectList)
    objectList = objectList.order(:name)
    objectList = objectList.includes(:event).select {|obj| obj.event == @event} if @event
    objectList = objectList.select { |obj| can? :_utilise, obj}
  end

  def available_booths
    available_booth_or_hall(Booth.all)
  end
  
  def available_halls
    available_booth_or_hall(Hall.all)
  end
  
  def available_events
    Event.all.order(:name).select {|event| can? :_utilise, event}
  end
  
  def client_is_ie?
    (request.user_agent.present? and request.user_agent =~ /Trident/i) 
  end
  
  def client_accepts_gz?
    (paperclip_environment? and !client_is_ie? and request.accept_encoding.present? and request.accept_encoding.downcase.split(",").include?("gzip"))
  end
  
  def link_tag_gz(tag_type, library, options = nil)
    case tag_type
    when :javascript
      if client_accepts_gz?
        view_context.javascript_include_tag(library, options).sub(/\.js/, ".js.gz").html_safe
      else
        view_context.javascript_include_tag(library, options)
      end
    when :stylesheet
      if client_accepts_gz?
        view_context.stylesheet_link_tag(library, options).sub(/\.css/, ".css.gz").html_safe
      else
        view_context.stylesheet_link_tag(library, options)
      end
    end
  end
end
