class AddDocToPresentation < ActiveRecord::Migration
  def change
    add_column :presentations, :doc, :string
  end
end
