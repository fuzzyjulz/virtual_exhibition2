class AddYoutubeIdAndIsCompleteToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :yt_youtube_id, :string
    add_column :videos, :is_complete, :boolean
  end
end
