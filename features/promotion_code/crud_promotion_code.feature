Feature: Allow promotion codes to be created, read, updated and deleted
  In order to administer the system's events
  An administrator and a booth rep
  Should be able to maintain the system's promotion codes
  In order to easily maintain events
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain promotion codes
  When I create a promotion code "PROMO001"
  Then I expect to have a promotion code "PROMO001"
  
  When I view the promotion code
  Then I expect to see the promotion code details
  
  When I delete the promotion code "PROMO001"
  Then I expect to not have a promotion code "PROMO001"
