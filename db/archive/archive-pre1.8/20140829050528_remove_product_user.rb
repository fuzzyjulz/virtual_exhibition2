class RemoveProductUser < ActiveRecord::Migration
  def change
    remove_column :products, :user_id
  end
end
