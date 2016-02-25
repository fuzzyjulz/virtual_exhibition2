class AddHallToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :hall, index: true
  end
end
