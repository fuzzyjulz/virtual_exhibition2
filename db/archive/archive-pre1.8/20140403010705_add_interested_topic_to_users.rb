class AddInterestedTopicToUsers < ActiveRecord::Migration
  def change
    add_column :users, :interested_topic, :string, limit: 2000
  end
end
