class AddStartAndEndToWebcasts < ActiveRecord::Migration
  def change
    add_column :webcasts, :start, :datetime
    add_column :webcasts, :duration, :string
  end
end
