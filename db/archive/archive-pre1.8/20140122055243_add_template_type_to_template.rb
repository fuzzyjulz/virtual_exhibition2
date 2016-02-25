class AddTemplateTypeToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :template_type, :string
  end
end
