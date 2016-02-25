class AddUserIdToBooth < ActiveRecord::Migration
  def change
    add_reference :booths, :user, index: true
  end
end
