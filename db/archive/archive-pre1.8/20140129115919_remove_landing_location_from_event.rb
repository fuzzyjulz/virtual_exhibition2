class RemoveLandingLocationFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :landing_location, :integer
  end
end
