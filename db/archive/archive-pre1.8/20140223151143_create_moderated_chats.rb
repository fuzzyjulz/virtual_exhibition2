class CreateModeratedChats < ActiveRecord::Migration
  def change
    create_table :moderated_chats do |t|
      t.text :message
      t.belongs_to :webcast, index: true
      t.integer :from_user_id, index: true
      t.integer :to_user_id, index: true
      t.boolean :approved

      t.timestamps
    end
  end
end
