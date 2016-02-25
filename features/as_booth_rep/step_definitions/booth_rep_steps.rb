Then(/^I see the booth rep dashboard$/i) do ||
  assert(page.has_content?("Welcome to the world of virtual events!"))
  assert(page.has_content?("Manage Booth"))
  assert(page.has_content?("Booth Chat"))
  assert(page.has_content?("Preview Booth"))
end
