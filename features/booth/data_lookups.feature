Feature: Users should be able to go to provided data extraction urls
  In order to ensure that the system still works as expected

Background:
  Given a basic event

@admin_logged_in
Scenario: A visitor goes to an event, but no events are recorded for the url or the event is not live
  When I visit "/events/#{@event.id}/booths.json"
  Then I expect to see the text:
    |All Content|
