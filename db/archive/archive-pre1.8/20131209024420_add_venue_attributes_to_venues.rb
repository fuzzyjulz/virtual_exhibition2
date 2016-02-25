class AddVenueAttributesToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :logo, :string
    add_column :venues, :whats_new, :boolean
    add_column :venues, :personal_map, :boolean
    add_column :venues, :display_webcast_rating, :boolean
    add_column :venues, :display_other_content_rating, :boolean
    add_column :venues, :closed_event_redirect, :boolean
    add_column :venues, :event_redirect_id, :integer
    add_column :venues, :display_on_demand_status, :boolean
    add_column :venues, :display_original_broadcast_date, :boolean
    add_column :venues, :venue_reports_url, :string
    add_column :venues, :support_message, :text
    add_column :venues, :venue_comments, :text
  end
end
