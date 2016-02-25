class AddTagTypeDescriptionToTags < ActiveRecord::Migration
  def change
    add_column :tags, :tag_type, :string
    add_column :tags, :description, :text
    execute("UPDATE tags SET tag_type = 'topic'")
  end
end
