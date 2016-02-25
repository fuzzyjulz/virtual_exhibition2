class AddTitleDescriptionToHall < ActiveRecord::Migration
  def change
    add_column :halls, :title, :string
    add_column :halls, :description, :text
  end
end
