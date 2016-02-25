class AddVenueIdToHalls < ActiveRecord::Migration
  def change
    add_reference :halls, :venue, index: true
  end
end
