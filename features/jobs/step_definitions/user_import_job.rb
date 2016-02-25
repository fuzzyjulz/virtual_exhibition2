When(/^I run the user import job for the file "(.*?)"$/i) do |importFile|
  inputFile = ""
  
  visit(events_dashboard_path)
  
  click_on "Import users"
  
  attach_file("importFile", "features/testfiles/#{importFile}")
  
  click_on "Import Users"
  
  File.open("features/testfiles/#{importFile}") do |file|
    inputFile = file.read
  end

  puts inputFile
  assert (page.has_content?("Job Status"))
  
  running_as = User.find_by(email: @current_user[:email])
  puts " "
  puts running_as.csv_file.content
end

Then(/^I expect to have (\d+?) users of the (system|"(.*?)" event)$/i) do |numberOfUsersStr, viewType, eventName|
  if eventName.present?
    expectedUserList = Event.find_by(name: eventName).users
  else
    expectedUserList = User.all
  end
  
  puts "#{expectedUserList.size} users"
  assert(numberOfUsersStr.to_i == expectedUserList.size)
end
