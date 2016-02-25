class AddHallRefToPresentation < ActiveRecord::Migration
  def change
    add_reference :presentations, :hall, index: true
  end
end
