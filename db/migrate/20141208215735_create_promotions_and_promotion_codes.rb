class CreatePromotionsAndPromotionCodes < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      
      t.belongs_to :booth
      t.timestamp :open_date
      t.timestamp :closed_date
      t.string :name
      t.text :description
      t.text :redemption_instructions
      t.integer :promotion_type
      t.string :promotion_url
      t.string :promotion_code
      t.timestamps
    end
    create_table :promotion_codes do |t|
      t.belongs_to :promotion
      t.string :code
      t.belongs_to :assigned_to_user
      t.belongs_to :reserved_by_shopping_cart
      t.timestamp :reserved_until
      t.timestamps
    end
  end
end
