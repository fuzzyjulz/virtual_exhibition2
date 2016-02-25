class CreateHalls < ActiveRecord::Migration
  def change
    create_table :halls do |t|
      t.string :name
      t.integer :template_id
      t.integer :background_id
      t.string :colour
      t.string :greeting
      t.string :greeting_type
      t.boolean :greeting_enable
      t.string :jumbotron
      t.boolean :jumbotron_enable

      t.timestamps
    end
  end
end
