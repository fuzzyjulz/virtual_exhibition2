class AddJoinTableBoothForum < ActiveRecord::Migration
  def change
    create_join_table :booths, :forums do |t|
      t.index [:booth_id, :forum_id]
      t.index [:forum_id, :booth_id]
    end
  end
end
