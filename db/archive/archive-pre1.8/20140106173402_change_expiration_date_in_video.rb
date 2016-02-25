class ChangeExpirationDateInVideo < ActiveRecord::Migration
  def change
  	remove_column :videos, :expiration_date
  	add_column :videos, :expiration_date, :datetime
  end
end
