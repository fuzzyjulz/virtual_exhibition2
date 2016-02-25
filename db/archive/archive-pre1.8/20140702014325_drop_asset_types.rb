class DropAssetTypes < ActiveRecord::Migration
  def change
    drop_table :asset_types
  end
end
