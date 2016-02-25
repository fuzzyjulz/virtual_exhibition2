Feature: Promotion Codes can be cleared out from the promotion screen
  In order to clean up erroneously created codes
  An administrator and a booth rep
  Should be able to maintain the system's promotion codes
  
Background:
  Given a basic public event
  
Scenario: Admins should be able to delete all unused promotion codes
  When I log in as the event admin
   And I view a promotion
   And I create a promotion code "PROMO001"
   And I create a promotion code "PROMO002"
   And I view a promotion
  Then I expect to see 0 used 0 reserved 3 total promotion codes
   And I log out
  
  When I am logged in as a visitor
   And I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
  Then I expect to not have an empty cart
   And I redeem my deals
  Then I expect to have an empty cart
   And I log out
  
  When I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
  Then I expect to not have an empty cart
  
  When I log in as the event admin
   And I view a promotion
  Then I expect to see 1 used 1 reserved 3 total promotion codes
   And I delete all promotion codes
  Then I expect to see the system message "Removed 1 code"
  Then I expect to see 1 used 1 reserved 2 total promotion codes
