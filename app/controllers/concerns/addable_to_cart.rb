module AddableToCart
  extend ActiveSupport::Concern
  
  def add_to_cart(parent_model)
    cart = my_cart(cookies)
    persist_cart(cart)
    
    cart_item = parent_model.reserve_cart_item(cart)
    
    cart.add(cart_item, 0) unless cart_item.nil?
    
    cart_item
  end
end
