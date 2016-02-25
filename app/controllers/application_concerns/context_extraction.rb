#Context Extraction for getting the @#{resource_name} variable, and filling
# in the related parent objects.
module ContextExtraction
  extend ActiveSupport::Concern
  
  included do
    before_action :set_context_objects
    before_action :set_overriding_context_objects
    before_action :role_variables
    before_action :set_current_event
  end
  
  protected
  def set_context_objects
    if (params[:id])
      instance_var = params[:controller].chop
      model_str = instance_var.gsub(/_/," ").titleize.gsub(" ","")
      model = Object.const_get(model_str)
      begin
        value = model.find(params[:id])
        instance_variable_set(:"@#{instance_var}", value)
      rescue ActiveRecord::RecordNotFound => e
        session[:previous_url] = nil
        respond_to do |format|
          record_event(GaEvent.new(category: :general, action: :invalid_url, label: request.original_url.gsub(/\//,"-"), user: current_user))
          format.html {redirect_to get_post_login_path, alert: "Could not find the #{model_str} requested."}
        end
      end
    end
  end
  
  def set_overriding_context_objects
    this_resource = resource
    if this_resource.present?
      @hall = this_resource.hall if defined? this_resource.hall
      @event = this_resource.event if defined? this_resource.event
      @promotion = this_resource.promotion if defined? this_resource.promotion
    end
    @booth ||= Booth.find(params[:booth_id]) if params[:booth_id]
    @hall ||= Hall.find(params[:hall_id]) if params[:hall_id]
    @event ||= Event.find(params[:event_id]) if params[:event_id]
    @promotion ||= Promotion.find(params[:promotion_id]) if params[:promotion_id]
    
    @event ||= @hall.event if @hall
    @event ||= @booth.event if @booth
    @event ||= @promotion.event if @promotion
  end

  def role_variables
    if user_signed_in?
      if current_user.has_role? :booth_rep
        @booth_rep_booth = current_user.booths.first
        @unread_chats = Chat.unread_count(@booth_rep_booth) if @booth_rep_booth.present?
        hide_sidebar 'hide-sidebar'
      end
    end
    if params[:action] == "visit"
      hide_sidebar 'hide-sidebar'
    end
  end
  
  def set_current_event
    if @event
      @current_event = @event
    else
      @current_event = get_event
    end
  end
end