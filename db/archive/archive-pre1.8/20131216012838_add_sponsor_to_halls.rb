class AddSponsorToHalls < ActiveRecord::Migration
  def change
    add_column :halls, :sponsors, :string
  end
end
