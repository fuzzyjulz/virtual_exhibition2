class AddExpirationToLiterature < ActiveRecord::Migration
  def change
    add_column :literatures, :expiration, :boolean
  end
end
