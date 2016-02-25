Feature: Users should be able to go to historic URLs
  In order to ensure that the system still works as expected for bookmarked urls

Background:
  Given a basic event

Scenario: A visitor goes to an event, but no events are recorded for the url or the event is not live
  When I open the home page
  Then I expect to not be logged in
   And I expect to be on the sign in page
   And I expect to be able to register

  When I visit "/events/#{@event.id}"
  Then I expect to be on the sign in page

  When I visit "/hall/#{Hall.all.first.id}"
  Then I expect to be on the sign in page

  When I visit "/booths/#{@all_content_booth.id}"
  Then I expect to be on the sign in page

  When I am logged in as a visitor
  Then I expect to be logged in
  
  When I visit "/events/#{@event.id}"
  Then I expect to see the Main Hall

  When I visit "/events/#{@event.id}/visit"
  Then I expect to see the Main Hall

  When I visit "/hall/#{Hall.all.first.id}"
  Then I expect to see the Main Hall

  When I visit "/booths/#{@all_content_booth.id}"
  Then I expect to be on booth "All Content"

  When I visit "/venues/1/hall/#{Hall.all.first.id}"
  Then I expect to see the Main Hall
  
  When I visit "/venues/1/hall/#{Hall.all.first.id}/visit"
  Then I expect to see the Main Hall
  
  When I visit "/hall/#{Hall.find_by(name: "Knowledge Central").id}?tag=#{Tag.find_by(name:"Knowledge Center: Amazeballs Videos").id}"
  Then I expect to see the knowledge library
   And I expect to see only content assigned to the tag "Knowledge Center: Amazeballs Videos"

  When I visit "/hall/#{Hall.find_by(name: "Knowledge Central").id}?previewContent=#{Content.find_by(name:"Knowledge Center: YouTube Video").id}"
  Then I expect to see the knowledge library
   And I expect to see the content details for content "Knowledge Center: YouTube Video"
  