Feature: Allow booths to be created, read, updated and deleted
  In order to administer the system's events
  An administrator
  Should be able to maintain the system's booths
  In order to easily maintain events
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain booths
  When I create a booth "Awesome Productions"
  Then I expect to have a booth "Awesome Productions"
  
  When I update the title of the booth to "Awesome Products" 
  Then I expect to not have a booth "Awesome Productions"
  And  I expect to have a booth "Awesome Products"
  
  When I view the booth
  Then I see the booth details
  
  When I delete the booth "Awesome Products"
  Then I expect to not have a booth "Awesome Products"
