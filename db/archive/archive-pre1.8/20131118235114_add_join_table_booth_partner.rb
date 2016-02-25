class AddJoinTableBoothPartner < ActiveRecord::Migration
  def change
    create_join_table :booths, :partners do |t|
      t.index [:booth_id, :partner_id]
      t.index [:partner_id, :booth_id]
    end
  end
end
