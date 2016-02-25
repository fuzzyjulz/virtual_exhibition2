class AddEventToBooths < ActiveRecord::Migration
  def change
    add_reference :booths, :event, index: true
  end
end
