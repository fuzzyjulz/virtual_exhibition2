class AddPromotionToBooths < ActiveRecord::Migration
  def change
    add_column :booths, :promotion_type, :integer
    add_column :booths, :promotion_url, :string
  end
end
