class CreateJoinTableBoothLiterature < ActiveRecord::Migration
  def change
    create_join_table :booths, :literatures do |t|
      t.index [:booth_id, :literature_id]
      t.index [:literature_id, :booth_id]
    end
  end
end
