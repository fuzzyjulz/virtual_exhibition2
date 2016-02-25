class AddHallRefToLiterature < ActiveRecord::Migration
  def change
    add_reference :literatures, :hall, index: true
  end
end
