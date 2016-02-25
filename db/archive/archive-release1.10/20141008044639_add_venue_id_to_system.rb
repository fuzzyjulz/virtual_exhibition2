class AddVenueIdToSystem < ActiveRecord::Migration
  def change
    add_column :booths, :venue_id, :integer
    
    create_join_table :users, :venues do |t|
      t.index [:venue_id, :user_id]
      t.index [:user_id, :venue_id]
    end
    
    migrate_data
  end
  
  def migrate_data
    execute("UPDATE booths 
              SET venue_id = e.venue_id 
              FROM events e 
              WHERE e.id = booths.event_id")
    
    execute("INSERT INTO users_venues (user_id, venue_id) 
              SELECT eu.user_id, e.venue_id 
              FROM events_users eu 
              INNER JOIN events e ON e.id = eu.event_id")
  end
end
