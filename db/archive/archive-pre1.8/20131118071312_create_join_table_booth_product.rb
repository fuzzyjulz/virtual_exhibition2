class CreateJoinTableBoothProduct < ActiveRecord::Migration
  def change
    create_join_table :booths, :products do |t|
      t.index [:booth_id, :product_id]
      t.index [:product_id, :booth_id]
    end
  end
end
