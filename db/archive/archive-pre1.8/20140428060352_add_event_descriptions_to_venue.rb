class AddEventDescriptionsToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :sponsor_tagline, :string
    add_column :venues, :event_welcome_heading, :string
    add_column :venues, :event_welcome_text, :text
  end
end
