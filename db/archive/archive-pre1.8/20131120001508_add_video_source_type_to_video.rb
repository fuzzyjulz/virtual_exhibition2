class AddVideoSourceTypeToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :video_source_type, :integer
  end
end
