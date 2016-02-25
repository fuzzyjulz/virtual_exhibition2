class AddSocialMediaToBooths < ActiveRecord::Migration
  def change
    add_column :booths, :twitter_url, :string
    add_column :booths, :linkedin_url, :string
    add_column :booths, :facebook_url, :string
  end
end
