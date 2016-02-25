When(/^I click through to the "(.*?)" booth$/i) do |boothName|
  visit_exhibition_hall
  @booth = Booth.find_by(name: boothName)
  assert(@booth.present?)
  find(:xpath, "//div[@class='booth' and @booth-id='#{@booth.id}']/a").click
  assert(page.has_content?(boothName))
end

When(/^I click About Us$/i) do ||
  click_on "About Us"
end

When(/^I click Booth Chat$/i) do ||
  chatButton = page.find("#booth-chat-btn")
  if chatButton[:href] == "#"
    page.find(".booth-chat-btn").click()
  else
    page.find("#booth-chat-btn").click()
  end
end

When(/^I add the booth deal to my cart$/i) do ||
  click_on "Add deal to my cart!"
end

When(/^I click Leave Business Card$/i) do ||
  leave_bus_card = page.all("#leaveCard").first
  if leave_bus_card.present?
    leave_bus_card.click()
  else
    page.find("a[@title='Contact Us']").click()
  end
end

When(/^I click Send Booth Message$/i) do ||
  page.find("#sendMessage").click()
end

When(/^I send the message "(.*?)"$/i) do |message|
  fill_in "message", with: "message"
  click_button("Send")
end

When(/^I click Resources$/i) do ||
  click_on "Resources"
end

When(/^I click on the booth's company website button$/i) do ||
  find("a[@title='Open our website']").click
end

Then(/^I expect to( not)? be on booth "(.*?)"$/i) do |notOn, boothName|
  assert(notOn.present? ^ page.has_content?("Back to Exhibition Hall"))

  @booth = Booth.find_by(name: boothName)
  
  assert(notOn.present? ^ (@booth.about_us.present? ^ !page.has_link?("About Us")))
  assert(notOn.present? ^ page.has_content?(@booth.top_message)) if @booth.top_message.present?
  assert(notOn.present? ^ page.find("div[@title='Leave My Details']").present?)
end

Then(/^I expect to see the booth$/i) do
  assert(page.has_content?(@booth.name))
  assert(!@booth.about_us.present? ^ (page.has_link?("About Us") || page.has_link?("Read more...")))
  assert(page.has_content?(@booth.top_message)) if @booth.top_message.present?
  #assert(page.find("div[@title='Leave My Details']").present?)
end

Then(/^I expect to see About Us content$/i) do
  assert(@booth.about_us.present?)
  assert(page.has_content?(@booth.about_us))
end

Then(/^I expect to see the booth chat screen$/i) do
  #this may not properly test this as it's a javascript object.
  #assert(page.has_content?("Booth chat"))
  #find("#chat-message")
end

Then(/^I expect to see the leave business card screen$/i) do
  assert(page.has_content?("Submit a virtual business card to the Exhibitor"))
end

Then(/^I expect to see the send booth message screen$/i) do
  assert(page.has_content?("Your contact information will be included from your profile"))
  assert(@booth.contact_info)
  assert(page.has_content?(@booth.contact_info))
end

Then(/^I expect to see the resource list$/i) do
  assert(page.has_content?("Resources"))
  @booth.contents.each {|content| assert(page.has_content?(content.name)) if content.is_content_type?(:resource)}
end

module VisitorBoothHelpers
end

World(VisitorBoothHelpers)
