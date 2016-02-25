class Promotion < ActiveRecord::Base
  include PaperclipUploadedFile
  
  belongs_to :booth
  has_many :promotion_codes
  has_one :event, through: :booth
  enum promotion_type: PromotionType::OPTIONS
  validates :promotion_type, :booth, :name, :open_date, :closed_date, presence: true

  paperclip_file promotion_image: UploadedFileType.promotion_image

  
  def live?
    open_date <= Time.now and Time.now < closed_date
  end
  
  def assigned_promotion_codes
    PromotionCode.assigned_promotion_codes(promotion_codes)
  end
  
  def reserved_promotion_codes
    PromotionCode.reserved_promotion_codes(promotion_codes)
  end

  def free_promotion_codes
    PromotionCode.free_promotion_codes(promotion_codes)
  end
  
  def reserved_promotion_code(shopping_cart)
    PromotionCode.reserved_promotion_codes(promotion_codes.where(reserved_by_shopping_cart: shopping_cart)).limit(1).first
  end
  
  def reserve_cart_item(shopping_cart)
    reserve_promotion_code(shopping_cart)
  end
  
  def reserve_promotion_code(shopping_cart)
    promotion_code = nil
    
    #renew the existing promotion code if this shooping cart already has it. Otherwise get a new one.
    promotion_code = promotion_codes.where(reserved_by_shopping_cart: shopping_cart).limit(1)
    if !promotion_code.present?
      promotion_code = free_promotion_codes.limit(1)
    end
    promotion_code.update_all(reserved_until: Time.now + 6.hours, 
                              reserved_by_shopping_cart_id: shopping_cart.id,
                              reserved_at: Time.now)
    
    reserved_promotion_code(shopping_cart)
  end
  
  def user_assigned_promotion_code(user)
    user.assigned_promotion_codes.select { |code| code.promotion == self }.first
  end
end
