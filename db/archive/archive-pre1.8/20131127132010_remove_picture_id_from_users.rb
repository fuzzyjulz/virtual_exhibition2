class RemovePictureIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :picture_id
  end
end
