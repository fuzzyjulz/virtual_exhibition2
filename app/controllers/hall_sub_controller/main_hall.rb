module MainHall
  extend ActiveSupport::Concern
  
  included do
    helper_method :knowledge_hall_tags_hall, :knowledge_center_featured_content
  end
  
  class MainHallController < HallsController::HallsSubController
    
    def visit()
      @booth_ids = Booth.where(event: hall.event).pluck(:id)
      @products = Product.joins(:booths).where(:booths_products => { :booth_id => @booth_ids.flatten }).limit(5).order(:id => :desc)
    end
  
    def knowledge_center_featured_content(maxNumberOfVideos = nil)
      knowledge_center_featured(:content, maxNumberOfVideos)
    end
    
    def knowledge_hall_tags_hall
      tagsHall = hall.event.knowledge_hall_tag_hall
      return nil if tagsHall.empty? 
      tagsHall[0]
    end
  end
end
