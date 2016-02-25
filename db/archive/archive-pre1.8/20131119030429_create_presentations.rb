class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.string :name
      t.text :description
      t.string :presentation_url
      t.integer :relevant_logo_id
      t.belongs_to :user, index: true
      
      t.references :relevant_logo, polymorphic: true
      t.timestamps
    end
  end
end
