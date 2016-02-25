When(/^I run the user export job for (all events|the "(.*?)" event)$/i) do |viewType, eventName|
  visit(events_dashboard_path)
  
  click_on "List users"
  
  if eventName.present?
    select eventName, from: "user_event_ids"
    click_on "Export"
  else
    click_on "Export All"
  end
  running_as = User.find(@admin_user.id)
  assert(running_as.csv_file.present?, "The CSV export file hasn't been set!")
  visit(running_as.csv_file.assets.url)
  puts page.html
end

Then(/^I expect to( not)? see users of the (system|"(.*?)" event( only)?)$/i) do |notAllowed, viewType, eventName, only|
  if eventName.present?
    expectedUserList = Event.find_by(name: eventName).users
    expectedUserList = expectedUserList.to_a.keep_if {|user| user.events.size == 1} if only
  else
    expectedUserList = User.all
  end
  
  puts "expecting #{expectedUserList.size} users"
  expectedUserList.each do |user|
    hasAllContent = page.has_content?(user.email) and page.has_content?(user.id) and user.email.present? and user.id.present?
    assert(notAllowed.present? ^ hasAllContent)
  end
end
