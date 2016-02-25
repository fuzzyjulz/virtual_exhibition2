class AddOriginToUser < ActiveRecord::Migration
  def change
    add_column :users, :origin, :string
  end
end
