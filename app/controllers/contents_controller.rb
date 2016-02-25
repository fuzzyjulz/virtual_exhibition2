class ContentsController < ApplicationController
  VIEW_CONTENT = [:show, :preview, :view, :sponsor]
  before_action :authenticate_user!, except: VIEW_CONTENT
  before_action :authenticate_user!, only: VIEW_CONTENT, if: Proc.new { |this| @content.present? and !(@content.publically_visibile?) }
  load_and_authorize_resource except: VIEW_CONTENT
  skip_load_resource :only => [:create]

  respond_to :html, :json
  responders :flash

  helper_method :available_tags, :available_users

  def index
    if (@event)
      @contents = Content.where(event: @event)
    else
      @contents = Content.all
    end 
    @contents = @contents.select {|content| can? :index, content}
    respond_with @contents
  end

  def show
  end

  def new
    @content = Content.new()
    
    @content.owner_user = current_user
    if @booth_rep_booth.present?
      @content.booths << @booth_rep_booth
    end
    @content.privacy = @event.privacy
    
    @content.event = @event
    #Extract the event from the user's events - for booth reps
    @content.event = @content.booths.first.hall.event if @content.event.nil? and @content.booths.present?
    
    build_resources
  end

  def create
    @content = Content.new(content_params)
    clenseContent()
    @content.save
    respond_with @content
  end
  
  def edit
    build_resources
  end
  
  def build_resources
    build_resource :resource_file, :thumbnail_image
  end

  def update
    @content.assign_attributes(content_params)
    clenseContent()
    @content.save
    respond_with @content
  end

  def destroy
    @content.destroy
    respond_with @content, location: event_contents_path(@content.event)
  end
  
  def clenseContent()
    case @content.content_type_code
      when :youtube_video
        cleanseContentByRegex(/v=([-\w]+)/)
      when :vimeo_video
        cleanseContentByRegex(/\/([0-9]+)$/i)
      when :wistia_video
        cleanseContentByRegex(/(?:.*)(?:wistia.com|wi.st)\/(?:medias|embed)\/(.+)/i)
      when :slideshare
    end
  end
  
  def cleanseContentByRegex(regexExp)
    return if @content.external_id.nil?
    matches = @content.external_id.match(regexExp)
    return if matches.nil? or matches.size != 2
    content_id = matches[1]
    if content_id.present?
      @content.external_id = content_id
    end
  end
  
  def preview
    if params[:ajax] != "true" and Role.find_by(name: :test_admin).nil?
      kc = @event.knowledge_halls.first
      return redirect_to hall_view_content_path(kc, @content) if kc.present?
    end
    render layout: "modal_box"
  end

  def view
    render layout: "modal_box"
  end
  
  def sponsor
    redirect_to content_preview_path(@content) unless @content.sponsor_booth.present?
    
    record_event(GaEvent.new(category: :booth, action: :clickthrough_from_preview_content, 
      label: "content:#{@content.id} - #{@content.name}").booth(@content.sponsor_booth))
    redirect_to booths_visit_path(@content.sponsor_booth)
  end
  
  def available_booths
    booths = (@content.booths | super).uniq
  end

  def available_halls
    halls = super.select {|hall| hall.knowledge_hall?}
    halls = (@content.halls | halls).uniq
  end
  
  def available_tags
    if @event
      @event.tags
    else
      []
    end
  end
  
  def available_users
    if current_user.has_role? :booth_rep
      User.where(:id => current_user.id).order(:first_name, :last_name)
    else
      User.admins_and_reps
    end
  end
  
private
  def content_params
    local_params = params.require(:content).permit(:name, :content_type, :external_id, :short_desc, :description,
      :sponsor_booth_id, :featured, :owner_user_id, :event_id, :privacy, :order_index,
      tag_ids: [], booth_ids: [], hall_ids: [], thumbnail_image_attributes: [:assets, :id], resource_file_attributes: [:assets, :id])
  end
end