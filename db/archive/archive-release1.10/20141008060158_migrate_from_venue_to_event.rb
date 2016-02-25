class MigrateFromVenueToEvent < ActiveRecord::Migration
  def change
    remove_column :booths, :event_id
    
    drop_table :events_users
    drop_table :events

    execute("DELETE FROM uploaded_files WHERE imageable_type = 'Event' AND image_type != 'event_image'")
    
    #These two are old and not required anymore.
    drop_table :admins
    drop_table :webcasts
    
    rename_table :venues, :events
    execute("UPDATE uploaded_files SET imageable_type = 'Event' WHERE imageable_type = 'Venue'")
    
    rename_table :auth_models_venues, :auth_models_events
    rename_column :auth_models_events, :venue_id, :event_id

    rename_table :users_venues, :events_users
    rename_column :events_users, :venue_id, :event_id
    
    rename_column :booths, :venue_id, :event_id
    rename_column :contents, :venue_id, :event_id
    rename_column :halls, :venue_id, :event_id
    rename_column :tags, :venue_id, :event_id

    rename_column :events, :hall_id, :landing_hall_id
  end
end
