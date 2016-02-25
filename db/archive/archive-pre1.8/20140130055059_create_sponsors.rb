class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :sponsorship_level
      t.string :link

      t.timestamps
    end
  end
end
