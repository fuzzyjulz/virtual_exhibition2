module KnowledgeTagHall
  extend ActiveSupport::Concern
  
  included do
    helper_method :knowledge_center_featured_tags
  end

  class KnowledgeTagHallController < HallsController::HallsSubController
    def visit
    end
    
    def knowledge_center_featured_tags(maxNumberOfVideos = nil)
      knowledge_center_featured(:tag, maxNumberOfVideos)
    end
  end
end