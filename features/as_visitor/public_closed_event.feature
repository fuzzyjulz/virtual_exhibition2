Feature: Users should be able to sign up for multiple events
  In order to access event content
  A visitor
  Should be able to sign up to a private event and then use the same credentials to sign into another event
  In order to make the use of the site(s) easier

Background:
  Given a basic public event


Scenario: A visitor goes to an event, but the event is not live
   And I open the home page
  Then I expect to not be logged in
  When I mark the event "First Event" as closed
   And I open the home page
  Then I expect to not be logged in

  When I visit "/booths/#{@all_content_booth.id}"
  Then I expect to be on the main hall
