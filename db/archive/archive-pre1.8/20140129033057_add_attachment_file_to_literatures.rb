class AddAttachmentFileToLiteratures < ActiveRecord::Migration
  def self.up
    change_table :literatures do |t|
      t.attachment :file
    end
  end

  def self.down
    drop_attached_file :literatures, :file
  end
end
