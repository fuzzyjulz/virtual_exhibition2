class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:dashboard, :privacy, :all_events_public]
  before_action :authenticate_user!, only: [:dashboard], if: Proc.new { |this| @current_event.present? and @current_event.private_scope? }
  load_and_authorize_resource :except => [:dashboard, :privacy, :all_events_public]
  skip_load_resource :only => [:create]
  before_action :sidebar_menu, only: CRUD_ACTIONS | [:dashboard]

  respond_to :html, :json
  responders :flash

  def self.menu(controller)
    items = [[controller.events_dashboard_path, "Dashboard"]]
    if controller.can? :new, @event
      items << [controller.new_event_path, "Create an event"]
    end
    items
  end
  
  def index
    @events = Event.all
  end

  def show
    @halls = Hall.where(ancestry: nil, event_id: @event.id)
  end

  def new
    @event = Event.new
    build_resources
  end

  def edit
    build_resources
  end
  
  def visit
    redirect_to event_landing_path(@event)
  end

  def build_resources
    build_resource :event_logo, :event_favicon, :main_sponsor_logo, :event_image
  end

  def create
    @event = Event.new(event_params)
    @event.save
    respond_with @event
  end

  def update
    @event.update(event_params)
    respond_with @event
  end

  def destroy
    @event.destroy
    respond_with @event
  end

  def get_public_events
    Event.get_public_events
  end
  
  def all_events
    if current_user.is_visitor?
      events = current_user.events
    else
      events = Event.all.select{|event| can? :_utilise, event}
    end
    render json: events
  end
  
  def all_events_public
    events = Event.get_public_events
    render json: events
  end  

  def dashboard
    UtmCampaign.create_campaign(session, request, params)
    
    if current_user.nil? or current_user.is_visitor?
      if (@current_event.present? and (current_user.present? or @current_event.public_scope?))
        if @current_event.live? or (@current_event.landing_hall.present? and @current_event.landing_hall.template.template_type.to_sym == :mainHall)
          redirect_to event_landing_path(@current_event)
        else
          @events = get_public_events
        end
      else
        @events = get_public_events
      end
    elsif current_user.has_role?(:booth_rep)
      @booths = current_user.booths
      @event = @booths.first.hall.event if @booths.present? and @booths.first.present?
      render "dashboard_booth_rep"
    else
      @events = Event.all.select {|event| can? :update, event}
      if @events.empty?
        @events = (current_user.events + get_public_events).uniq
      end
    end
  end

  def general_settings
  end

  def privacy
    hide_sidebar 'hide-sidebar'
  end
private
    def event_params
      params.require(:event).permit(:name, :user_id, :colour, :event_welcome_heading, :event_welcome_text, :sponsor_tagline,
        :start, :finish, :event_url, :landing_hall_id, :main_tagline, :additional_info,
        :whats_new, :personal_map, :display_webcast_rating, :display_other_content_rating, :closed_event_redirect,
        :display_on_demand_status, :display_original_broadcast_date, :venue_reports_url, :support_message, :venue_comments, :privacy,
        :can_register, :topics_title, :keynotes_title, :signup_panel,
        {auth_model_ids: []},
        {event_logo_attributes: [:assets, :id]},
        {event_favicon_attributes: [:assets, :id]},
        {event_image_attributes: [:assets, :id]},
        {main_sponsor_logo_attributes: [:assets, :id]},
        :main_sponsor_url)
    end
end
