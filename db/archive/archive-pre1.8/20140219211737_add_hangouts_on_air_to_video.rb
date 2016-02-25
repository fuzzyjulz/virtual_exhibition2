class AddHangoutsOnAirToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :hangouts, :boolean, :default => false
  end
end
