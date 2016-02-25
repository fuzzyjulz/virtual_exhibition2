class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :from_user_id, index: true
      t.integer :to_user_id, index: true
      t.text :message

      t.timestamps
    end
  end
end
