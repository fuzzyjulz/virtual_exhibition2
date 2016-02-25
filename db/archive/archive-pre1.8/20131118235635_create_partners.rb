class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.text :description
      t.string :partner_url
      t.string :logo_id
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
