class CreateLiteratures < ActiveRecord::Migration
  def change
    create_table :literatures do |t|
      t.string :name
      t.string :file_category
      t.belongs_to :asset_type, index: true
      t.datetime :expiration_date
      t.boolean :share
      t.text :description
      t.string :file_url
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
