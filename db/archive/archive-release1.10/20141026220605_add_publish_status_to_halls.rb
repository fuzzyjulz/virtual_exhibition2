class AddPublishStatusToHalls < ActiveRecord::Migration
  def change
    add_column :halls, :publish_status, :integer
    execute("UPDATE halls SET publish_status = 1")
  end
end
