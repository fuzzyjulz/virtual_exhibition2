class AddHallTypeToHall < ActiveRecord::Migration
  def change
    add_column :halls, :hall_type, :string
  end
end
