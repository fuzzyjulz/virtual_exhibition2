class AddOrderIndexToContents < ActiveRecord::Migration
  def change
    add_column :contents, :order_index, :integer
  end
end
