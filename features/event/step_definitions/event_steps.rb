When(/^I open the event list$/i) do
  visit(events_dashboard_path)
end

When(/^I edit a event$/i) do
  visit(edit_event_path(Event.first.id))
end

When(/^I create a[n]?( open| future| closed)? event "(.*)"$/i) do |openTime, eventName|
  openTime = " open" if openTime.nil?
  parameters = {name: eventName, privacy: Privacy[:private_scope].label, auth_models: [AuthModel.direct]}
  case openTime
    when " open"
      parameters[:start] = "1/1/2000"
      parameters[:finish] = "1/1/2099"
    when " future"
      parameters[:start] = "1/1/2050"
      parameters[:finish] = "1/1/2099"
    when " closed"
      parameters[:start] = "1/1/1999"
      parameters[:finish] = "1/1/2000"
  end
  @event = report_errors {create_event(parameters)}
end

When(/^I switch the current event to ("(.*?)"|be nothing)$/i) do |isNothingStr, eventName|
  eventName = nil if isNothingStr == "to be nothing"
  Event.all.each do |event|
    if eventName.present? and event.name == eventName
      event.event_url = testing_event_url
      event.save!
    else
      if event.event_url.present?
        event.event_url = nil
        event.save!
      end
    end
  end
end

When(/^I mark the event "(.*?)" as closed$/i) do |eventName|
  event = Event.find_by(name: eventName)
  assert(event.present?)
  event.start = "2014-01-01"
  event.finish = "2014-01-01"
  event.save!
end

When(/^I update the title of the event to "(.*?)"$/i) do |newEventName|
  assert(@event.present?)
  
  open_event(@event)
  click_on "Edit"
  
  fill_in "event_name", with: newEventName
  click_button "Update Event"
  report_errors {@event}
  @event.name = newEventName
end

When(/^I view the event "(.*?)"$/i) do |eventName|
  @event = Event.find_by(name: eventName)
  assert(@event.present?)
  
  open_event(@event)
end

When(/^I view the event$/i) do ||
  assert(@event.present?)
  
  open_event(@event)
end

When(/^I delete the event "(.*?)"$/i) do |eventName|
  pending
end

Then(/^I see the event details$/i) do
  assert(page.has_content?("Event details"))
  
  assert(page.has_content?(@event.name))

  assert(page.has_content?(@event.landing_hall.name)) if @event.landing_hall.present?
  assert(page.has_content?(@event.start.utc.strftime("%d-%b-%Y")))
  assert(page.has_content?(@event.finish.utc.strftime("%d-%b-%Y")))
end

Then(/^I expect to( not)? have a event "(.*?)"$/i) do |notHave, eventName|
  visit(events_dashboard_path)
  assert(page.has_content?(eventName)) if notHave.nil?
  assert(!page.has_content?(eventName)) if notHave.present?
  puts Event.pluck(:name)
end

Then(/^I expect to( not)? see the "(.*?)" event$/i) do |notAllowed, eventName|
  event = Event.find_by(name: eventName)
  isAllowed = !notAllowed.present?
  assert(event.present?)
  
  assert(!isAllowed ^ page.has_content?("Featured in the Knowledge Center Tags List"))
  assert(!isAllowed ^ page.has_content?("Browse Knowledge Center Tags List"))
  assert(!isAllowed ^ page.has_content?("Discover what our Exhibitors have on offer"))
  
  assert(!isAllowed ^ page.has_content?(event.event_welcome_heading))
end

Then(/^I expect the user to only be assigned events:$/i) do |table|
  user_events = @current_user.events.pluck(:name)
  required_events = table.transpose.raw[0]
  Event.all.each() do |event|
    if (required_events.include?(event.name))
      assert(user_events.include?(event.name), "Event #{event.name} is not in the user's event list")
    else
      assert(!user_events.include?(event.name), "Event #{event.name} is in the user's event list, but should not be")
    end
  end
  
end

Then(/^I expect to see no events$/i) do
  Event.all.each() do |event|
    assert(!page.has_content?(event.name), "Event #{event.name} found but was not expected")
  end
end

module EventHelpers
  def create_event(options)
    visit(new_event_path)
    
    fill_in "event_name", with: options[:name]
    select options[:privacy], from: "event_privacy" if options[:privacy].present?
    if options[:auth_models].present?
      options[:auth_models].each do |model|
        select model.name, from: "event_auth_model_ids"
      end
    end
    fill_in "event_start", with: options[:start]
    fill_in "event_finish", with: options[:finish]
    select options[:entry_hall].name, from: "event_landing_hall_id" if options[:entry_hall]
  
    click_button "Create Event"
    Event.find_by(name: options[:name])
  end
  
  def open_event(event)
    visit(events_dashboard_path)
    within("#content") {click_on event.name}
  end
end

World(EventHelpers)
