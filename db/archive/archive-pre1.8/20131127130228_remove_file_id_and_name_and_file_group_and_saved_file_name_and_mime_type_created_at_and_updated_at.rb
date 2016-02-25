class RemoveFileIdAndNameAndFileGroupAndSavedFileNameAndMimeTypeCreatedAtAndUpdatedAt < ActiveRecord::Migration
  def change
  	remove_columns :uploaded_files, :file_id, :name, :file_group, :saved_file_name, :mime_type, :updated_at, :created_at
  end
end
