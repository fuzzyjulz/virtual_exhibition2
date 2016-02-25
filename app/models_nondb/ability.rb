class Ability
  include CanCan::Ability

  def can(subject = nil, action = nil, conditions = nil, &block)
    rules << CanCan::Rule.new(true, action, subject, conditions, block)
  end
  
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    
    alias_action :read, :new, :create, :index, :update, :destroy, to: :crud  
    alias_action :visit, :about, :leave_business_card, :products, :literature, :contact,  
      :contact_info, :chat_widget, :send_message, :send_business_card, :add_promotion_to_cart, to: :booth_actions
    
    if user.has_role? :admin
      can(:all, :manage)
    elsif user.has_role? :producer
      base_abilities user
      priviliged_user user
      producer user
    elsif user.has_role? :booth_rep
      base_abilities user
      priviliged_user user
      booth_rep user
    elsif user.has_role? :visitor
      base_abilities user
    end
  end
  
  :private
  def producer(user)
    can(User,     [:show, :show_basic_info])                { |edituser| edituser.id.nil? or (edituser.has_role?(:admin) and producer_can_access_user?(user, edituser))}
    can(User,     [:manage])                                { |edituser| edituser.id.nil? or (!edituser.has_role?(:admin) and producer_can_access_user?(user, edituser))}
    can(Event,    [:dashboard, :all_events, :_event_dashboard, :visit])
    can(Event,    [:update, :_utilise, :_admin, :_basic_admin])  { |event| user.events.include?(event)}
    can(Booth,    [:manage, :_utilise])                     { |booth| producer_can_access_object?(user, booth)}
    can(Promotion,[:manage])                                { |promo| producer_can_access_object?(user, promo)}
    can(PromotionCode,[:manage])                            { |promoCode| producer_can_access_object?(user, promoCode)}
    can(Hall,      :manage)                                 { |hall| producer_can_access_object?(user, hall)}
    can(Product,   :manage)                                 { |product| producer_can_access_object?(user, product)}
    can(Content,   :manage)                                 { |content| producer_can_access_object?(user, content)}
    can(Tag,       :manage)                                 { |tag| producer_can_access_object?(user, tag)}
    can(Chat,      :manage)                                 { |chat| producer_can_access_chat?(producer, chat)}
  end
  
  def producer_can_access_user?(producer, edit_user)
    producer.events.select {|event| edit_user.events.include?(event)}.present?
  end
  
  def producer_can_access_object?(producer, object)
    object.id.nil? or producer.events.include?(object.event)
  end
  
  def producer_can_access_chat?(producer, chat)
    return true if chat.id.nil?
    
    if chat.chattable_type == "Booth"
      booth = Booth.find(chat.chattable_id)
      
      return true if producer.events.select {|event| event.booths.include?(booth) }.present?
    end
    return false
  end
  
  def booth_rep(user)
    can(User,     [:show_basic_info])
    can(Event,    [:_utilise, :_basic_admin])               { |event| user.booths.each {|booth| booth.event == event}}
    can(Booth,    [:edit, :update, :booth_rep, :_utilise],  :user_id => user.id)
    can(Promotion,[:manage])                                { |promo| booth_rep_can_access_object?(user, promo)}
    can(PromotionCode,[:manage])                            { |promoCode| booth_rep_can_access_object?(user, promoCode)}
    can(Hall,     [:_utilise])                              { |hall| user.booths.each {|booth| booth.hall == hall}}
    can(Product,   :manage)                                 { |product| product.id.nil? or user.booths.select {|booth| product.booths.include?(booth)}.present?}
    can(Content,  [:crud],                                  :owner_user_id => user.id)
    can(Chat,      :manage)                                 { |chat| booth_rep_can_access_chat?(user, chat)}
  end
  
  def booth_rep_can_access_object?(booth_rep, object)
    object.id.nil? or booth_rep.booths.include?(object.booth)
  end
  
  def booth_rep_can_access_chat?(booth_rep, chat)
    return true if chat.id.nil?
    
    if chat.chattable_type == "Booth"
      booth = Booth.find(chat.chattable_id)
      
      return true if booth_rep.booths.include?(booth)
    end
    return false
  end
    
  def priviliged_user(user)
    can(User,     [:status, :update],                       :id => user.id)
    can(Event,    [:read, :_dashboard_menu])
    can(Booth,    [:read])
  end

  def base_abilities(user)
    can(Event,     :dashboard, :visit)
    can(User,      :edit,                                   :id => user.id)
    can(Hall,      :visit)
    can(Booth,    [:booth_actions])
    can(Chat,      :manage,                                 :from_user_id => user.id)
    can(Content,  [:view,:preview, :sponsor])
    can(ShoppingCart,[:visit, :redeem, :remove_item])
  end
end
