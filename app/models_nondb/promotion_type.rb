class PromotionType
  ENUM = [{id: :external_site, label: "External Site"},
          {id: :std_cart_deal, label: "Standard Cart Deal"}]

  include EnumBase
end
