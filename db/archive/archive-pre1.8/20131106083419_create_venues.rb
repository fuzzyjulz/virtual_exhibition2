class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.belongs_to :user, index: true
      t.string :colour
      t.string :background_image

      t.timestamps
    end
  end
end
