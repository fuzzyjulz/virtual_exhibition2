class AddImageTypeToUploadedFile < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :image_type, :string
  end
end
