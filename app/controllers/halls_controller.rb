class HallsController < ApplicationController
  VIEW_CONTENT = [:visit]
  
  class HallsSubController
    include DelegateTo
    
    attr_reader :halls_controller
    delegate_to class: :halls_controller
    
    def initialize(halls_controller)
      @halls_controller = halls_controller
    end
  end
  
  include DelegateTo
  include KnowledgeHall
  include KnowledgeTagHall
  include MainHall
  include ExhibitionHall

  before_action :authenticate_user!, except: VIEW_CONTENT
  before_action :authenticate_user!, only: VIEW_CONTENT, if: Proc.new { |this| @current_event.present? and @current_event.private_scope?}
  load_and_authorize_resource :except => VIEW_CONTENT
  skip_load_resource :only => [:create]
  before_action :not_live_event, if: Proc.new { |this| @hall.nil? || @hall.event.nil? ? false : !@hall.event.live?}
    
  respond_to :html, :json
  responders :flash

  helper_method :get_templates, :sub_controller
  helper_method :style, :background_image
  delegate_to class: :sub_controller
  delegate_to class: :sub_controller, method: :visit
  
  attr_reader :hall
  
  def background_image
    if request["action"] == "visit" and @hall.present? 
      if @hall.background_image.present?
        @hall.background_image.url
      elsif @hall.template.uploaded_file.present?
        @hall.template.uploaded_file.url
      else
        nil
      end
    else
      nil
    end
  end
  
  def not_live_event
    if request["action"] == "visit" and @hall.present? and @hall.template.template_type.to_sym == :mainHall
    else
      super
    end
  end

  # GET /halls
  def index
    @halls = Event.find(params[:event_id]).halls.order(:name)
    if params[:hall_type].present?
      @halls = Hall.get_hall_by_type(@halls, params[:hall_type].to_sym, params[:sub_hall_type].to_sym)
    end
    respond_with(@halls)
  end

  # GET /halls/1
  def show
    redirect_to hall_path(@hall) if current_user.is_visitor?
  end

  # GET /halls/new
  def new
    @hall = Hall.new
    build_resources
    @hall.event = @event
    @hall.publish_status = PublishStatus.draft.id
  end

  # GET /halls/1/edit
  def edit
    build_resources
    @event.id = @hall.id unless @event
  end
  
  def build_resources
    build_resource :event_logo, :thumbnail_image, :background_image
  end

  # POST /halls
  def create
    @hall = Hall.new(page_params)
    @hall.save
    respond_with(@hall)
  end

  # PATCH/PUT /halls/1
  def update
    @hall.update(page_params)
    respond_with(@hall)
  end

  # DELETE /halls/1
  def destroy
    @hall.destroy
    redirect_to event_halls_path(@event), notice: 'Hall was successfully destroyed.'
  end

  def style
    if @hall and @hall.template
      @hall.template.template_sub_type
    else
      nil
    end
  end
  
  def sub_controller
    @sub_controller ||= new_sub_controller
    @sub_controller
  end
  
  def new_sub_controller
    if @hall.exhibition_hall?
      ExhibitionHallController.new(self)
    elsif @hall.main_hall?
      MainHallController.new(self)
    elsif @hall.knowledge_hall_tag_hall?
      KnowledgeTagHallController.new(self)
    elsif @hall.knowledge_hall?
      KnowledgeHallController.new(self)
    end
  end
  
  def get_templates
    Template.where.not(template_type: :booth)
  end
  
  def knowledge_center_featured(type, maxNumberOfVideos = nil)
    if knowledge_hall = @hall.event.knowledge_hall
      case(type)
        when(:content)
          items = knowledge_hall.contents.where("featured = 'true'")
        when(:tag)
          items = knowledge_hall.tags.where("tags.featured = 'true'")
        else
          raise "That type isn't supported"
      end
      items = items[0, maxNumberOfVideos] if maxNumberOfVideos.present?
      items
    else
      []
    end
  end
  
  private
    def page_params
      params.require(:hall).permit(:name, :title, :description, :template_id, :event_id, :hall_type,
        :parent_id, :welcome_video_content_id, :publish_status,
        thumbnail_image_attributes: [:assets, :id], event_logo_attributes: [:assets, :id], background_image_attributes: [:assets, :id], 
        sponsor_ids: [])
    end
end
