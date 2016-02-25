class AddThumbnailUrlToPresentation < ActiveRecord::Migration
  def change
    add_column :presentations, :thumbnail_url, :string
  end
end
