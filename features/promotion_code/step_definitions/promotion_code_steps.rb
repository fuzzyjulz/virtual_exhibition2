When(/^I open the promotion code list$/i) do
  list_promotion_codes_direct
end

When(/^I edit a promotion code$/i) do
  @promotion_code = PromotionCode.first if @promotion_code.nil?
  visit(edit_promotion_code_path(@promotion_code.id))
end

Then(/^I create a promotion code "(.*?)"$/i) do |promotionCode|
  promotion = @promotion.nil? ? Promotion.first : @promotion
  parameters = {code: promotionCode}

  @promotion_code = create_promotion_code(promotion, parameters)
  puts @promotion_code.to_json
  assert(@promotion_code.present?)
end

Then(/^I expect to( not)? have a promotion code "(.*?)"$/i) do |notAllowed, promotionCode|
  list_promotion_codes
  assert(notAllowed.present? ^ page.has_content?(promotionCode))
end

Then(/^I view the promotion code$/i) do ||
  assert(@promotion_code.present?)
  view_promotion_code_by_code(@promotion_code.code)
end

Then(/^I update the title of the promotion code to "(.*?)"$/i) do |promotionCodeName|
  list_promotion_codes
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{@promotion_code.name}']") {click_on "Edit"}
  
  fill_in "promotion_code_name", with: promotionCodeName
  click_on "Update Promotion Code"
  report_errors {@promotion_code}
  @promotion_code.name = promotionCodeName
end

Then(/^I delete the promotion code "(.*?)"$/i) do |promotionCodeName|
  list_promotion_codes
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{promotionCodeName}']") {click_on "Delete"}
end

Then(/^I expect to( not)? see the promotion code details$/i) do |notAllowed|
  assert(@promotion_code.present?)
  assert(notAllowed.present? ^ page.has_content?("View Promotion Code"))
  assert(notAllowed.present? ^ page.has_content?(@promotion_code.code))
end

module ContentHelpers
  def create_promotion_code(promotion, options)
    view_promotion_by_name(promotion.name)
    click_on "List Promotion Codes"
    
    click_on "New Promotion Code"
    prefix = "promotion_code_"
    
    fill_in "#{prefix}code", with: options[:code]

    click_button "Create Promotion code"
    report_errors { PromotionCode.find_by(promotion: promotion, code: options[:code]) }
  end
  
  def list_promotion_codes()
    list_promotions
    if @promotion
      within(:xpath, "//div[@id='content']//table//tr[td//text()='#{@promotion.name}']") {click_on "View"}
    else
      click_on "View"
    end
    click_on "List Promotion Codes"
  end
  def list_promotion_codes_direct()
    visit promotion_promotion_codes_path(@all_content_booth_v2.promotions.first)
  end
  
  def view_promotion_code_by_code(promotionCode)
    list_promotion_codes
    page.within(:xpath, "//div[@id='content']//table//tr[td//text()='#{promotionCode}']") {click_on "View"}
  end
end

World(ContentHelpers)
