class AddQnaAndApprovedToChat < ActiveRecord::Migration
  def change
    add_column :chats, :qna, :boolean
    add_column :chats, :approved, :boolean
  end
end
