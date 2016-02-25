Feature: Allow Events to be created, read, updated and deleted
  In order to administer the system's events
  An administrator
  Should be able to maintain the system's events
  In order to easily maintain events
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain events
  When I create a event "World Exhibition"
  Then I expect to have a event "World Exhibition"
  
  When I update the title of the event to "Australia's Exhibition" 
  Then I expect to not have a event "World Exhibition"
  And  I expect to have a event "Australia's Exhibition"
  
  When I view the event
  Then I see the event details
  
  #When I delete the event "Australia's Exhibition"
  #Then I expect to not have a event "Australia's Exhibition"
  