class CreateJoinTableBoothTag < ActiveRecord::Migration
  def change
    create_join_table :booths, :tags do |t|
      t.index [:booth_id, :tag_id]
      t.index [:tag_id, :booth_id]
    end
  end
end
