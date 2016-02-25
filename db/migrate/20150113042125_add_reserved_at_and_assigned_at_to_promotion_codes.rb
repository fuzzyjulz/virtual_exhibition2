class AddReservedAtAndAssignedAtToPromotionCodes < ActiveRecord::Migration
  def change
    add_column :promotion_codes, :reserved_at, :timestamp
    add_column :promotion_codes, :assigned_at, :timestamp
  end
end
