class AddShortDescToVideosLiteraturePresentations < ActiveRecord::Migration
  def change
    add_column :videos, :short_desc, :string
    add_column :literatures, :short_desc, :string
    add_column :presentations, :short_desc, :string
  end
end
