class AddFollowUsLinksToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :followus_url_twitter, :string
    add_column :booths, :followus_url_facebook, :string
    add_column :booths, :followus_url_linkedin, :string
    add_column :booths, :followus_url_googleplus, :string
  end
end
