class AddCanRegisterToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :can_register, :boolean
  end
end
