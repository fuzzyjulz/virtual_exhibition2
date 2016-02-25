Feature: Allow Halls to be created, read, updated and deleted
  In order to administer the system's events
  An administrator
  Should be able to maintain the system's halls
  In order to easily maintain events
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain halls
  When I create a hall "Joes Hall"
  Then I expect to have a hall "Joes Hall"
  
  When I update the title of the hall to "Freds Hall" 
  Then I expect to not have a hall "Joes Hall"
  And  I expect to have a hall "Freds Hall"
  
  When I view the hall
  Then I see the hall details
  
  When I delete the hall "Freds Hall"
  Then I expect to not have a hall "Freds Hall"
