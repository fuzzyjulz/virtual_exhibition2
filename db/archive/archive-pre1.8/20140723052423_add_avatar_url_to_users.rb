class AddAvatarUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :external_avatar_url, :string
  end
end
