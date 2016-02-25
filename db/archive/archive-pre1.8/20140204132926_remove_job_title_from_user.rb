class RemoveJobTitleFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :job_title, :string
  end
end
