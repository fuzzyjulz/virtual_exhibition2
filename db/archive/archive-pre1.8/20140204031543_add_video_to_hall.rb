class AddVideoToHall < ActiveRecord::Migration
  def change
    add_reference :halls, :video, index: true
  end
end
