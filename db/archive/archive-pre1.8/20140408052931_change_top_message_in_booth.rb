class ChangeTopMessageInBooth < ActiveRecord::Migration
  def change
    change_column :booths, :top_message, :text
  end
end
