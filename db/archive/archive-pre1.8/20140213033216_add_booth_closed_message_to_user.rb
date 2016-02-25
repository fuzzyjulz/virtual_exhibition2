class AddBoothClosedMessageToUser < ActiveRecord::Migration
  def change
    add_column :users, :booth_closed_message, :text
  end
end
