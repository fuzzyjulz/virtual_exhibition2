class CreateBooths < ActiveRecord::Migration
  def change
    create_table :booths do |t|
      t.string :name
      t.string :company_website
      t.text :social_media
      t.text :contact_info
      t.string :email
      t.text :about_us
      t.integer :greeting_type

      t.timestamps
    end
  end
end
