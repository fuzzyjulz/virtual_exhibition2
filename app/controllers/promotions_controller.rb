class PromotionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  skip_load_resource :only => [:create]

  respond_to :html, :json
  responders :flash
  
  helper_method :new_promotion_path, :index_promotion_path, :export_promotion_path

  def index
    if (@booth.present?)
      @promotions = Promotion.joins(:booth).where(booth: @booth)
    elsif (@event.present?)
      @promotions = Promotion.joins(:booth).where("booths.event"=> @event)
    end
  end
  
  def new_promotion_path()
    if (@booth.present?)
      new_booth_promotion_path(@booth)
    elsif (@event.present?)
      new_event_promotion_path(@event)
    end
  end

  def index_promotion_path()
    if (@booth.present?)
      booth_promotions_path(@booth)
    elsif (@event.present?)
      event_promotions_path(@event)
    end
  end
  
  def export_promotion_path()
    if (@promotion.present?)
      promotion_export_path(@promotion)
    elsif (@booth.present?)
      booth_promotions_export_path(@booth)
    elsif (@event.present?)
      event_promotions_export_path(@event)
    end
  end

  def new
    @promotion.booth = @booth
    build_resources
  end

  def create
    @promotion = Promotion.new(clensed_params)
    build_resources
    @promotion.save
    respond_with @promotion
  end

  def edit
    build_resources
  end

  def update
    resource.update(clensed_params)
    respond_with resource
  end

  def destroy
    resource.delete
    respond_with(resource, location: event_promotions_path(resource.event))
  end

  private
  def build_resources
    build_resource :promotion_image
  end
      
  def clensed_params
    params.require(:promotion).permit(:name, :open_date, :closed_date, :description,
      :booth_id, :redemption_instructions, :promotion_type, :promotion_url, :promotion_code,
    promotion_image_attributes: [:assets, :id])
  end
end