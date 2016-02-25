class AddMainTaglineAdditionalInfoToEvent < ActiveRecord::Migration
  def change
    add_column :events, :main_tagline, :text
    add_column :events, :additional_info, :text
  end
end
