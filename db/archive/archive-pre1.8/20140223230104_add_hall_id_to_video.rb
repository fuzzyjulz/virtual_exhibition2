class AddHallIdToVideo < ActiveRecord::Migration
  def change
    add_reference :videos, :hall, index: true
  end
end
