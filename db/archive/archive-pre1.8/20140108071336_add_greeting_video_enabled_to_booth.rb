class AddGreetingVideoEnabledToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :greeting_video_enabled, :boolean
  end
end
