class AddPresentationUrlTypeToPresentation < ActiveRecord::Migration
  def change
    add_column :presentations, :presentation_url_type, :integer
  end
end
