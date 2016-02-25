class AddTitlesAndSignUpPanelToEvent < ActiveRecord::Migration
  def change
    add_column :events, :topics_title, :string
    add_column :events, :keynotes_title, :string
    add_column :events, :signup_panel, :text
  end
end
