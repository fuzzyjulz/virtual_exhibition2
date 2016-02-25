class AddImageableToUploadedFiles < ActiveRecord::Migration
  def self.up
    change_table :uploaded_files do |t|
      t.references :imageable, :polymorphic => true
    end
  end

  def self.down
    change_table :uploaded_files do |t|
      t.remove_references :imageable, :polymorphic => true
    end
  end
end
