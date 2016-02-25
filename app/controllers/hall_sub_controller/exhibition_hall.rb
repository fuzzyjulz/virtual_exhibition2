module ExhibitionHall
  extend ActiveSupport::Concern

  included do
  end
  
  class ExhibitionHallController < HallsController::HallsSubController
    def visit()
      @all_exhibition_halls = Hall.get_hall_by_type(hall.siblings, :exhibitionHall, :exhibition_hall)
        
      @exhibition_halls = @all_exhibition_halls.where("id NOT IN(?)", hall.id).order(:name => :desc) 
      @prev_hall = @all_exhibition_halls.where("halls.name < ?", hall.name).order(:name => :desc).first
      @next_hall = @all_exhibition_halls.where("halls.name > ?", hall.name).order(:name => :asc).first
    end
  end
end
