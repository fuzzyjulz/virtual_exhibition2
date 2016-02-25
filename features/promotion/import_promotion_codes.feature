Feature: Promotion Codes can be imported from the promotion screen
  In order to bulk create promotion codes
  An administrator and a booth rep
  Should be able to maintain the system's promotion codes
  
Background:
  Given a basic event
  
Scenario: Admins should be able to maintain promotions
  When I log in as the event admin
   And I view a promotion
  Then I expect to see 0 used 0 reserved 1 total promotion codes
  
  When I import promotion codes using "promotion_import.csv"
  Then I view a promotion
   And I expect to see 0 used 0 reserved 10 total promotion codes
   And I expect to have a promotion code "FS1000"
   And I expect to have a promotion code "PROMOCODE1"
   And I expect to have a promotion code "PM6"
   And I expect to have a promotion code "CODE9"
