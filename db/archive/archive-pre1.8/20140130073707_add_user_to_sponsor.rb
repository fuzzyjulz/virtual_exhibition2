class AddUserToSponsor < ActiveRecord::Migration
  def change
    add_reference :sponsors, :user, index: true
  end
end
