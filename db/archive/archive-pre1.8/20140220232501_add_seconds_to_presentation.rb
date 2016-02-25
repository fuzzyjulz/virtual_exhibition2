class AddSecondsToPresentation < ActiveRecord::Migration
  def change
    add_column :presentations, :seconds, :string
  end
end
