class AddProductUrlTypeToProduct < ActiveRecord::Migration
  def change
    add_column :products, :product_url_type, :string
  end
end
