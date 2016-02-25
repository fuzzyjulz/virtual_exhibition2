class AddHallToBooths < ActiveRecord::Migration
  def change
    add_reference :booths, :hall, index: true
  end
end
