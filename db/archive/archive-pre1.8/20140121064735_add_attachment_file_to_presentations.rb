class AddAttachmentFileToPresentations < ActiveRecord::Migration
  def self.up
    change_table :presentations do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :presentations, :file
  end
end
