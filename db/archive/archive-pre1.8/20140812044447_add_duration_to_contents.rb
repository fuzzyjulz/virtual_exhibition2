class AddDurationToContents < ActiveRecord::Migration
  def change
    add_column :contents, :duration, :integer
  end
end
