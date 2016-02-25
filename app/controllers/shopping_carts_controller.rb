class ShoppingCartsController < ApplicationController
  include ShoppingCartHelper
  UNAUTHENTICATED_PAGES = [:visit, :remove_item]
  
  before_action :authenticate_user!, except: UNAUTHENTICATED_PAGES
  before_action :authenticate_user!, only: UNAUTHENTICATED_PAGES, if: Proc.new { |this| @current_event.present? and @current_event.private_scope? }
  load_and_authorize_resource :except => UNAUTHENTICATED_PAGES
  before_action :set_shopping_cart_context
  
  def visit
  end

  def redeem
    promotion_codes = @shopping_cart.shopping_cart_items.map {|cart_item| cart_item.item}
    
    promotion_codes.each do |promo_code|
      promo_code.assign_to_user(current_user)
    end
    
    @shopping_cart.clear

    send_redemption_emails(promotion_codes)
    
    redirect_to shopping_cart_path
  end
  
  def send_redemption_emails(promotion_codes)
    send_user_redeem_promotion_email(promotion_codes)
    promotion_codes.each do |promo_code|
      send_sponsor_code_redeemed_email(promo_code)
      record_event(GaEvent.new(category: :booth, action: :redeem_promotion, 
        label: "promotion_code:#{promo_code.promotion.id}").booth(promo_code.promotion.booth))
    end
  end
  
  def remove_item
    cart_item_id = params.require(:shopping_cart_item)
    @shopping_cart.shopping_cart_items.each do |item|
      if item.id == cart_item_id.to_i
        item.item.unreserve!
        item.delete
      end
    end
    redirect_to shopping_cart_path
  end
  
  def set_shopping_cart_context
    @event = @current_event
    @shopping_cart = my_cart(cookies)
  end
  
  def send_user_redeem_promotion_email(promotion_codes)
    mail = UserMailer.send_user_redeem_promotion_email(@current_event, current_user, promotion_codes)
    mail.deliver if Role.find_by(name: :test_admin).nil?
  end
  
  def send_sponsor_code_redeemed_email(promotion_code)
    mail = UserMailer.send_sponsor_code_redeemed_email(@current_event, current_user, promotion_code)
    mail.deliver if Role.find_by(name: :test_admin).nil?
  end
end