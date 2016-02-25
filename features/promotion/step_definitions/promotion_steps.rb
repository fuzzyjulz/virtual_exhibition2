When(/^I open the promotion list$/i) do
  list_promotions
end

When(/^I edit a promotion$/i) do
  @promotion = Promotion.first if @promotion.nil?
  visit(edit_promotion_path(@promotion.id))
end

When(/^I view the "(.*?)" promotion$/i) do |promotion_name|
  @promotion = Promotion.find_by(name: promotion_name)
  view_promotion_by_name(@promotion.name)
end

When(/^I view a promotion$/i) do
  @promotion = Promotion.first if @promotion.nil?
  view_promotion_by_name(@promotion.name)
end

When(/^I import promotion codes using "(.*?)"$/i) do |importFile|
  inputFile = ""
  
  view_promotion_by_name(@promotion.name)
  
  attach_file("importFile", "features/testfiles/#{importFile}")
  
  find(".importCodes").click
  
  File.open("features/testfiles/#{importFile}") do |file|
    inputFile = file.read
  end

  puts inputFile
  assert (page.has_content?("Job Status"))
  
  running_as = User.find_by(email: @current_user[:email])
  puts " "
  puts running_as.csv_file.content
end

When(/^I delete all promotion codes$/i) do
  view_promotion_by_name(@promotion.name)
  find("a[text()='Delete All Codes']",:visible=>false).click
end

When(/^I generate promotion codes$/i) do
  view_promotion_by_name(@promotion.name)
  click_button "Generate Codes"
end

When(/^I generate promotion codes with template "(.*?)"$/i) do |template|
  view_promotion_by_name(@promotion.name)
  fill_in "promo_code_template", with: template
  click_button "Generate Codes"
end

When(/^I export promotion codes$/) do
  view_promotion_by_name(@promotion.name)
  find("a[text()='Export Codes']",:visible=>false).click
  find(".downloadFile").click
  puts (page.html)
end

When(/^I export promotion codes for booth "(.*?)"$/) do |booth_name|
  open_booth(Booth.find_by(name: booth_name))
  click_on "View"
  click_on "Promotions"
  find("a[text()='Export Promotions']",:visible=>false).click
  find(".downloadFile").click
end

When(/^I export promotion codes for event "(.*?)"$/) do |event_name|
  @event = Event.find_by(name: event_name)
  
  open_event(@event)
  click_on "List promotions"
  find("a[text()='Export Promotions']",:visible=>false).click
  find(".downloadFile").click
end

When(/^I create a promotion "(.*?)"$/i) do |promotionName|
  booth = @booth.nil? ? @all_content_booth : @booth
  event = Event.first
  parameters = {name: promotionName, promotion_type: :std_cart_deal, open_date: "2012-01-01", closed_date: "2020-01-01", booth: booth}

  @promotion = create_promotion(event, parameters)
  puts @promotion.to_json
  assert(@promotion.present?)
end

When(/^I view the promotion$/i) do ||
  assert(@promotion.present?)
  view_promotion_by_name(@promotion.name)
end

When(/^I update the title of the promotion to "(.*?)"$/i) do |promotionName|
  list_promotions
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{@promotion.name}']") {click_on "Edit"}
  
  fill_in "promotion_name", with: promotionName
  click_on "Update Promotion"
  report_errors {@promotion}
  @promotion.name = promotionName
end

When(/^I delete the promotion "(.*?)"$/i) do |promotionName|
  list_promotions
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{promotionName}']") {click_on "Delete"}
end

Then(/^I expect to( not)? have a promotion "(.*?)"$/i) do |notAllowed, promotionName|
  list_promotions
  assert(notAllowed.present? ^ page.has_content?(promotionName))
end

Then(/^I expect the promotion code export to( not)? contain "(.*?)"$/i) do |notAllowed, text|
  assert(notAllowed.present? ^ html.include?(text))
end

Then(/^I expect to see (\d+) used (\d+) reserved (\d+) total promotion codes$/i) do |used, reserved, total|
  assert(page.has_content?("#{used} / #{reserved} / #{total}"))
end

Then(/^I expect to( not)? see the promotion details$/i) do |notAllowed|
  assert(@promotion.present?)
  assert(notAllowed.present? ^ page.has_content?("View Promotion"))
  assert(notAllowed.present? ^ page.has_content?(@promotion.name))
end

module ContentHelpers
  def create_promotion(event, options)
    open_event(event)
    
    click_on "Create promotion"
    prefix = "promotion_"
    
    fill_in "#{prefix}name", with: options[:name]
    fill_in "#{prefix}open_date", with: options[:open_date]
    fill_in "#{prefix}closed_date", with: options[:closed_date]
    select options[:booth].name, from: "#{prefix}booth_id" if options[:booth]
    select PromotionType[options[:promotion_type]].label, from: "#{prefix}promotion_type" if options[:promotion_type]

    click_button "Create Promotion"
    report_errors { Promotion.find_by(name: options[:name]) }
  end
  
  def list_promotions()
    if @current_user.has_role?(:visitor)
      visit(event_promotions_path(Event.first))
    elsif @current_user.has_role?(:booth_rep)
      visit_home_page()
      click_on "Core Booth Setup"
      click_on "Promotions"
    else
      open_event(Event.first)
      click_on("List promotions")
    end
  end
  
  def view_promotion_by_name(promotionName)
    list_promotions
    page.within(:xpath, "//div[@id='content']//table//tr[td//text()='#{promotionName}']") {click_on "View"}
  end
end

World(ContentHelpers)
