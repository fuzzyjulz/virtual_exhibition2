Then(/^I expect to be on the event dashboard page$/i) do
  assert(page.has_content?("Select from list of available events"))
  assert(page.has_content?("Event calendar"))
end

module VisitorHelpers
end

World(VisitorHelpers)
