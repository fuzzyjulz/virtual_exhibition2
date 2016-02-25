Feature: Allow promotions to be created, read, updated and deleted
  In order to administer the system's events
  An administrator and a booth rep
  Should be able to maintain the system's promotions
  In order to easily maintain events
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain promotions
  When I create a promotion "Julians Awesome Videos"
  Then I expect to have a promotion "Julians Awesome Videos"
  
  When I update the title of the promotion to "Julians Amazeballs Videos" 
  Then I expect to not have a promotion "Julians Awesome Videos"
  And  I expect to have a promotion "Julians Amazeballs Videos"
  
  When I view the promotion
  Then I expect to see the promotion details
  
  When I delete the promotion "Julians Amazeballs Videos"
  Then I expect to not have a promotion "Julians Amazeballs Videos"
