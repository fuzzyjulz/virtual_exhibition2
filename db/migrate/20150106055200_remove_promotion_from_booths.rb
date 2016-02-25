class RemovePromotionFromBooths < ActiveRecord::Migration
  def change
    remove_column :booths, :promotion_type
    remove_column :booths, :promotion_url
  end
end
