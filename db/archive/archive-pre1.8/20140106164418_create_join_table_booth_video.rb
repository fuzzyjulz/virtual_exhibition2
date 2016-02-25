class CreateJoinTableBoothVideo < ActiveRecord::Migration
  def change
    create_join_table :booths, :videos do |t|
      t.index [:booth_id, :video_id]
      t.index [:video_id, :booth_id]
    end
  end
end
