class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :product_url
      t.integer :image_id
      t.boolean :request_info
      t.boolean :email_notification
      t.string :emails
      t.belongs_to :user, index: true

      t.timestamps
    end
    add_index :products, :image_id
  end
end
