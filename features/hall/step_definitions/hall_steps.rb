When(/^I open the hall list$/i) do
  visit(event_halls_path(Event.first.id))
end

When(/^I edit a hall$/i) do
  visit(edit_hall_path(Hall.first.id))
end

When(/^I create a hall "(.*)"$/i) do |hallName|
  event = Event.first
  parameters = {name: hallName, template: @main_hall_template}
  @hall = report_errors {create_hall(event, parameters)}
end

When(/^I update the title of the hall to "(.*?)"$/i) do |newHallName|
  assert(@hall.present?)
  
  open_hall(@hall)
  click_on "Edit"
  
  fill_in "hall_name", with: newHallName
  click_button "Update Hall"
  report_errors {@hall}
  @hall.name = newHallName
end

When(/^I view the hall$/i) do ||
  assert(@hall.present?)
  
  open_hall(@hall)
end

When(/^I delete the hall "(.*?)"$/i) do |hallName|
  open_event(@event)
  click_on "List halls"
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{hallName}']") {click_on "Destroy"}
end

Then(/^I see the hall details$/i) do
  assert(page.has_content?("Show hall"))
  
  assert(page.has_content?(@hall.name))
  assert(page.has_content?(@hall.event.name))
  assert(page.has_content?(@hall.template.name))
end

Then(/^I expect to( not)? see the Main Hall$/i) do |notAllowed|
  isAllowed = !notAllowed.present?
  assert(!isAllowed ^ page.has_content?("Featured in the Knowledge Center Tags List"))
  assert(!isAllowed ^ page.has_content?("Browse Knowledge Center Tags List"))
  assert(!isAllowed ^ page.has_content?("Discover what our Exhibitors have on offer"))
end

Then(/^I expect to( not)? see the Exhibitor Hall$/i) do |notAllowed|
  assert(notAllowed ^ page.all(".exhibition_hall_title").size != 0)
end

Then(/^I expect to( not)? have a hall "(.*?)"$/i) do |notHave, hallName|
  visit(event_halls_path(Event.first.id))
  assert(page.has_content?("Listing Halls"))
  assert(page.has_content?(hallName)) if notHave.nil?
  assert(! page.has_content?(hallName)) if notHave.present?
  puts Hall.pluck(:name)
end

module HallHelpers
  def create_hall(event, options)
    open_event(event)
    
    click_on "Create hall"
    
    fill_in "hall_name", with: options[:name]
    select options[:template].name, from: "hall_template_id" if options[:template]
    
    click_button "Create Hall"
    Hall.find_by(name: options[:name])
  end

  def open_hall(hall)
    visit(events_dashboard_path)
    open_event(hall.event)
    within(:xpath, "//div[@id='content']") {click_on hall.name}
  end
end

World(HallHelpers)
