class AddHashTagsToHall < ActiveRecord::Migration
  def change
    add_column :halls, :hash_tags, :string
  end
end
