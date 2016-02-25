class AddThumbnailUrlToContents < ActiveRecord::Migration
  def change
    add_column :contents, :thumbnail_url, :string
  end
end
