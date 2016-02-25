class AddAncestryToHalls < ActiveRecord::Migration
  def change
    add_column :halls, :ancestry, :string
    add_index :halls, :ancestry
  end
end
