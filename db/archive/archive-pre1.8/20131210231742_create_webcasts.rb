class CreateWebcasts < ActiveRecord::Migration
  def change
    create_table :webcasts do |t|
      t.string :name
      t.belongs_to :hall, index: true
      t.string :webcast_type
      t.string :media_type
      t.belongs_to :user, index: true
      t.string :details
      t.belongs_to :template, index: true
      t.string :background_colour

      t.timestamps
    end
  end
end
