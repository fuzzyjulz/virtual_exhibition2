class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.integer :file_id
      t.string :name
      t.string :file_group
      t.string :saved_file_name
      t.string :mime_type

      t.timestamps
    end
  end
end
