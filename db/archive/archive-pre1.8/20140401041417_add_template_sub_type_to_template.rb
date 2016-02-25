class AddTemplateSubTypeToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :template_sub_type, :string
  end
end
