class RemoveBackgroundImageFromVenue < ActiveRecord::Migration
  def change
    remove_column :venues, :background_image, :string
  end
end
