class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :status
      t.datetime :start
      t.datetime :finish
      t.string :event_url
      t.string :event_reports_url
      t.integer :landing_location
      t.string :logo1
      t.string :logo2
      t.string :top_bar_background
      t.string :colour
      t.boolean :publish_event
      t.string :event_image
      t.text :description
      t.string :search_keywords
      t.string :closed_event_redirect
      t.text :comments
      t.belongs_to :venue, index: true

      t.timestamps
    end
    add_index :events, :landing_location
  end
end
