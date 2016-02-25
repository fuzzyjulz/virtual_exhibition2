class AddGreetingImageIdAndGreetingAudioIdAndGreetingVideoIdAndGreetingVirtualHostIdToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :greeting_image_id, :integer
    add_column :booths, :greeting_audio_id, :integer
    add_column :booths, :greeting_video_id, :integer
    add_column :booths, :greeting_virtual_host_id, :integer

    add_index :booths, :greeting_image_id
  	add_index :booths, :greeting_audio_id
  	add_index :booths, :greeting_video_id
  	add_index :booths, :greeting_virtual_host_id
  end
end
