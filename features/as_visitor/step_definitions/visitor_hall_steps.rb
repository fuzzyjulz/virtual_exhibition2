When(/^I click through to the main hall$/i) do ||
  visit_main_hall
end

Then(/^I expect to( not)? be on the main hall$/i) do |notAllowed|
  main_hall_div = all(".controller-halls.action-visit.style-main_hall")
  assert(notAllowed.present? ^ (main_hall_div.size > 0))
  assert(notAllowed.present? ^ page.has_content?(@event.event_welcome_heading))
end

module VisitorHallHelpers
  def visit_main_hall 
    visit_home_page
    if admin?
      click_on_menu @event.name
      click_on "Visit"
    elsif admin_or_producer?
      click_on @event.name
      click_on "Visit"
    elsif booth_rep_or_producer?
      click_on_visitor_menu @event.main_halls.first.name
    else 
      visit("/")
    end
  end
  
  def visit_exhibition_hall
    visit_main_hall
    click_on_visitor_menu @event.exhibition_halls.first.name
  end
end

World(VisitorHallHelpers)
