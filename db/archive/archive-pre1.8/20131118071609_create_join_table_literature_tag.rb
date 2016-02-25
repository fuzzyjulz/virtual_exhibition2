class CreateJoinTableLiteratureTag < ActiveRecord::Migration
  def change
    create_join_table :literatures, :tags do |t|
      t.index [:literature_id, :tag_id]
      t.index [:tag_id, :literature_id]
    end
  end
end
