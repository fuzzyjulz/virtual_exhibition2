class PromotionCode < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :reserved_by_shopping_cart, class_name: "ShoppingCart"
  has_one :event, through: :promotion
  has_one :booth, through: :promotion
  validates :promotion, :code, presence: true
  belongs_to :assigned_to_user, class_name: "User"
  
  def assigned?
    assigned_to_user.present?
  end

  def reserved?
    (assigned_to_user.nil? and reserved_until.present? and reserved_until > Time.now) 
  end
  
  def available?
    (assigned_to_user.nil? and (reserved_until.nil? or reserved_until < Time.now)) 
  end
  
  def assign_to_user(user)
    update!(assigned_to_user: user, reserved_by_shopping_cart_id: nil, reserved_until: nil,
            assigned_at: Time.now)
  end
  
  def unreserve!()
    update!(reserved_by_shopping_cart_id: nil, reserved_until: nil, reserved_at: nil)
  end
  
  def self.assigned_promotion_codes(promotion_codes = PromotionCode)
    promotion_codes.where("assigned_to_user_id is not null")
  end
    
  def self.reserved_promotion_codes(promotion_codes = PromotionCode)
    promotion_codes.where("reserved_until is not null and reserved_until > now() and assigned_to_user_id is null")
  end
  
  def self.free_promotion_codes(promotion_codes = PromotionCode)
    promotion_codes.where("(reserved_until is null or reserved_until < now()) and assigned_to_user_id is null")
  end
end
