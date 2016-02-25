class AddEventColumnsToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :start, :datetime
    add_column :venues, :finish, :datetime
    add_column :venues, :event_url, :string
    add_column :venues, :hall_id, :integer
    
    migrate_data
  end
  
  def migrate_data
    execute("UPDATE venues
              SET start = e.start
                ,finish = e.finish
                ,event_url = e.event_url
                ,hall_id = e.hall_id
              FROM events e 
              WHERE e.venue_id = venues.id")
  end
end
