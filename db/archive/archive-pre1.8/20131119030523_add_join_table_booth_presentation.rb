class AddJoinTableBoothPresentation < ActiveRecord::Migration
  def change
    create_join_table :booths, :presentations do |t|
      t.index [:booth_id, :presentation_id]
      t.index [:presentation_id, :booth_id]
    end
  end
end
