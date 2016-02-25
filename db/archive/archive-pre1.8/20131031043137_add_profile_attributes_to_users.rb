class AddProfileAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :title, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :position, :string
    add_column :users, :work_phone, :string
    add_column :users, :company, :string
  end
end
