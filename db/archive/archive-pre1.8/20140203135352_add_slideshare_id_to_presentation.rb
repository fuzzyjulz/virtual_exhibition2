class AddSlideshareIdToPresentation < ActiveRecord::Migration
  def change
    add_column :presentations, :slideshare_id, :integer
  end
end
