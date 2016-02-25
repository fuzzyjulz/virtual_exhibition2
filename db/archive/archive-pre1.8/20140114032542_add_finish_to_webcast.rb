class AddFinishToWebcast < ActiveRecord::Migration
  def change
    add_column :webcasts, :finish, :datetime
  end
end
