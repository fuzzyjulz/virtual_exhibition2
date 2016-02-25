class AddPolymorphicTypeToChat < ActiveRecord::Migration
  def self.up
    change_table :chats do |t|
      t.references :chattable, :polymorphic => true
    end
  end

  def self.down
    change_table :chats do |t|
      t.remove_references :chattable, :polymorphic => true
    end
  end
end
