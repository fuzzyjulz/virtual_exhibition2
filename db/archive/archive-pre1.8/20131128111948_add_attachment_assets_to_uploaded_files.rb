class AddAttachmentAssetsToUploadedFiles < ActiveRecord::Migration
  def self.up
    change_table :uploaded_files do |t|
      t.attachment :assets
    end
  end

  def self.down
    drop_attached_file :uploaded_files, :assets
  end
end
