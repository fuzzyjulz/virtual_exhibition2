class AddButtonToBooth < ActiveRecord::Migration
  def change
    add_column :booths, :button1_label, :string
    add_column :booths, :button1_content, :text
  end
end
