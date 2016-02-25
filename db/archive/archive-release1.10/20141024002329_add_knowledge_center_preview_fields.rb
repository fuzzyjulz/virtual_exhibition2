class AddKnowledgeCenterPreviewFields < ActiveRecord::Migration
  def change
    add_column :booths, :related_sponsor_tagline, :text
    add_column :tags, :related_sponsors_text, :string
  end
end
