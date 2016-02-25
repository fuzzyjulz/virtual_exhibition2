class AddSponsorToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :sponsor_id, :integer, references: :booths
  end
end
