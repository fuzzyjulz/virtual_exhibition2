class AddTaglineToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :tagline, :string
  end
end
