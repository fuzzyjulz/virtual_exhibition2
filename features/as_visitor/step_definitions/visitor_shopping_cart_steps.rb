When(/^I redeem my deals$/i) do
  open_shopping_cart
  click_on "Redeem all deals"
end

When(/^I view my cart$/i) do
  open_shopping_cart
end

Then(/^I remove the deal "(.*?)" from my cart$/i) do |deal_name|
  within(:xpath, "//tr[td/text() = '#{deal_name}']") {find(".removeBtn a").click}
end

Then(/^I expect to( not)? have an empty cart$/i) do |notAllowed|
  within("#shoppingcart") { assert(notAllowed.present? ^ page.has_content?("0")) }
end

module VisitorShoppingCartHelpers
  def open_shopping_cart
    find("#shoppingcart").click
    assert(page.has_content?("Deals in Your Cart"))
  end
end

World(VisitorShoppingCartHelpers)
