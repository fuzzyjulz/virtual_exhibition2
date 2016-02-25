class HallsSponsors < ActiveRecord::Migration
  def change
  	create_table :halls_sponsors, :id => false do |t|
  		t.integer :hall_id
  		t.integer :sponsor_id
  	end
  end
end
