class AddGreetingVideoToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :greeting_video, :string
  end
end
