class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.boolean :jumbotron_available

      t.timestamps
    end
  end
end
