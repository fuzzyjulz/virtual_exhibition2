class AddMessagesToBooths < ActiveRecord::Migration
  def change
    add_column :booths, :top_message, :string
  end
end
