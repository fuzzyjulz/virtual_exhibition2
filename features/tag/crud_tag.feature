Feature: Allow tags to be created, read, updated and deleted
  In order to administer the system's events
  An administrator and a booth rep
  Should be able to maintain the system's tags
  In order to easily maintain events
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain tags
  When I create a tag "Julians Awesome Videos"
  Then I expect to have a tag "Julians Awesome Videos"
  
  When I update the title of the tag to "Julians Amazeballs Videos" 
  Then I expect to not have a tag "Julians Awesome Videos"
  And  I expect to have a tag "Julians Amazeballs Videos"
  
  When I view the tag
  Then I expect to see the tag details
  
  When I delete the tag "Julians Amazeballs Videos"
  Then I expect to not have a tag "Julians Amazeballs Videos"
