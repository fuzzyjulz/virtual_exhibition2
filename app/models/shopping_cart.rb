class ShoppingCart < ActiveRecord::Base
  acts_as_shopping_cart
  belongs_to :owner_user, class_name: "User"
  
  def clense_cart
    promotions_reserved = []
    assigned_promotions = owner_user.nil? ? [] : owner_user.assigned_promotion_codes.map {|promo_code| promo_code.promotion}
    
    shopping_cart_items.each do |sc_item|
      #Don't keep items that are no longer reserved, or not in this cart
      if (!sc_item.item.reserved? or sc_item.item.reserved_by_shopping_cart != self)
        shopping_cart_items.delete(sc_item)
      end
      
      #Should only have one reserved item in the cart for each promotion.
      if assigned_promotions.include?(sc_item.item.promotion) or promotions_reserved.include?(sc_item.item.promotion)
        sc_item.item.unreserve!
        shopping_cart_items.delete(sc_item)
      else
        promotions_reserved << sc_item.item.promotion
      end
      
    end
  end
  
  def move_items_in_cart(other_cart)
    other_cart.shopping_cart_items.each do |sc_item|
      add(sc_item.item, sc_item.price, sc_item.quantity)
      sc_item.item.update!(reserved_by_shopping_cart: self)
      other_cart.shopping_cart_items.delete(sc_item)
    end
  end
end