class AddCartUuidToShoppingCarts < ActiveRecord::Migration
  def change
    add_column :shopping_carts, :cart_uuid, :string
  end
end
