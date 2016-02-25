class AddStateAndIndustryToUser < ActiveRecord::Migration
  def change
    add_column :users, :state, :string
    add_column :users, :industry, :string
  end
end
