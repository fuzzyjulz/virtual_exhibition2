class AddDisplayModeToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :display_mode, :boolean
  end
end
