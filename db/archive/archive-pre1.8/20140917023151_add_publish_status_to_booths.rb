class AddPublishStatusToBooths < ActiveRecord::Migration
  def change
    add_column :booths, :publish_status, :integer
    #set to published.
    execute "update booths set publish_status = 1"
  end
end
