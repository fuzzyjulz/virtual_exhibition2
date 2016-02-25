class AddBoothPackageToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :booth_package, :integer
  end
end
