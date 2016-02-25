class AddWidgetLocationsToWebcast < ActiveRecord::Migration
  def change
    add_column :webcasts, :widget_locations, :hstore
  end
  
  def self.up
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
  end
  
end
