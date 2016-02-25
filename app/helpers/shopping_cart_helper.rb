module ShoppingCartHelper
  def my_cart(cookies)
    if @shopping_cart
      return @shopping_cart
    end
    
    @shopping_cart = get_cart
    if @shopping_cart
      #Check if we already have this user in the database
      if @shopping_cart.owner_user.nil? and current_user.present?
        user_shopping_cart = ShoppingCart.find_by(owner_user: current_user)
        if user_shopping_cart
          user_shopping_cart.move_items_in_cart @shopping_cart
          @shopping_cart.delete
          @shopping_cart = user_shopping_cart
          set_cart(@shopping_cart)
        end
      end
      if @shopping_cart
        @shopping_cart.update!(owner_user: current_user) if current_user.present? and @shopping_cart.owner_user.nil?
        set_cart(@shopping_cart)
        return @shopping_cart
      end
    end
    
    if current_user.present?
      @shopping_cart = ShoppingCart.find_by(owner_user: current_user)
      if @shopping_cart
        set_cart(@shopping_cart)
        return @shopping_cart
      end
    end
    
    @shopping_cart = create_cart
    @shopping_cart.owner_user = current_user if current_user.present?
    
    return @shopping_cart
  end
  
  def persist_cart(cart)
    if !cart.persisted?
      if cart.save
        set_cart(cart)
      else
        flash[:error] = "Couldn't save the cart"
      end
    end
  end
  
  def create_cart
    ShoppingCart.new.tap do |cart|
      cart.cart_uuid = SecureRandom.uuid
    end
  end
  
  def set_cart(cart)
    if cart.nil?
      cookies[:shopping_cart_id] = nil
    else
      cart.clense_cart
      cookies[:shopping_cart_id] = {value: cart.cart_uuid, expires: 1.year.from_now}
    end
  end
  
  def get_cart()
    shopping_cart_id = cookies[:shopping_cart_id]
    return nil unless shopping_cart_id.present?
    ShoppingCart.find_by(cart_uuid: shopping_cart_id)
  end
end