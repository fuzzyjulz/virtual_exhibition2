class CreateShoppingCartsAndShoppingCartItems < ActiveRecord::Migration
  def change
    create_table :shopping_carts do |t|
      t.belongs_to :owner_user
    end
    create_table :shopping_cart_items do |t|
      t.shopping_cart_item_fields
    end
  end
end
