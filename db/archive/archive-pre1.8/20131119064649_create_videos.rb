class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :file_category
      t.belongs_to :asset_type, index: true
      t.string :expiration_date
      t.boolean :share
      t.text :description
      t.string :video_source
      t.integer :video_duration
      t.string :thumbnail

      t.timestamps
    end
  end
end
