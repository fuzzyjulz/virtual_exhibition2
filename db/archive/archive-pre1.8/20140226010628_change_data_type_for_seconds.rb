class ChangeDataTypeForSeconds < ActiveRecord::Migration
  def change
  	change_column :presentations, :seconds, :text
  end
end
