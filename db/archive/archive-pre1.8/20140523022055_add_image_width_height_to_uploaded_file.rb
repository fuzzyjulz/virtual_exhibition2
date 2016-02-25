class AddImageWidthHeightToUploadedFile < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :image_width, :integer
    add_column :uploaded_files, :image_height, :integer
  end
end
