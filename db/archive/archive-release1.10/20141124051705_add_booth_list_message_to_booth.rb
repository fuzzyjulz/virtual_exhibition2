class AddBoothListMessageToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :booth_list_message, :text
  end
end
