class AddFileUrlTypeToLiterature < ActiveRecord::Migration
  def change
    add_column :literatures, :file_url_type, :integer
  end
end
