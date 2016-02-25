class AddVenueToContent < ActiveRecord::Migration
  def change
    add_column :contents, :venue_id, :integer, references: :venue
    
    Content.all.each do |content|
      content.booths.each do |booth|
        content.venue ||= booth.hall.venue if booth.hall and booth.hall.venue
      end
      content.halls.each do |hall|
        content.venue ||= hall.venue if hall.venue
      end
      if content.venue.nil? and content.owner_user
        content.owner_user.booths.each do |booth|
          content.venue ||= booth.hall.venue if booth.hall and booth.hall.venue
        end
        content.owner_user.events.each do |event|
          content.venue ||= event.venue if event.venue
        end
      end
      if content.venue
        content.save!
      end
    end
  end
end
