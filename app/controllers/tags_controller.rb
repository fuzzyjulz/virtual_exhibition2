class TagsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :except => [:show]
  skip_load_resource :only => [:create]

  respond_to :html, :json
  responders :flash
  
  helper_method :get_events, :get_contents, :get_booths
  
  def index
    @tags = Tag.where(event_id: @event) if @event
    @tags = Tag.all unless @event
    @tags = @tags.select {|tag| can? :index, tag}
    
    respond_with @tags
  end

  def show
  end

  def new
    @tag = Tag.new()
    @tag.event = @event
    build_resources
  end

  def create
    @tag = Tag.new(content_params)
    @tag.save

    respond_with @tag
  end
  
  def edit
    build_resources
  end
  
  def build_resources
    build_resource :thumbnail_image
  end

  def update
    @tag.update(content_params)
    
    respond_with @tag
  end

  def destroy
    @tag.destroy
    
    respond_with @tag, location: event_tags_path(@tag.event)
  end
  
  def get_events
    @events ||= Event.all.select{|event| can? :_utilise, event}
  end

  def get_contents
    return [] if !@event.present?
    @event.contents | @tag.contents
  end

  def get_booths
    return [] if !@event.present?
    event_booths = []
    @event.halls.each do |hall|
      event_booths += hall.booths
    end
    event_booths | @tag.booths
  end
  
private
  def content_params
    params.require(:tag).permit(:name, :description, :event_id, :featured, :tag_type, :related_sponsors_text, booth_ids: [], content_ids: [], thumbnail_image_attributes: [:assets, :id])
  end
end