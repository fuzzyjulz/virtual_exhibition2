Feature: Promotion Codes can be generated from the promotion screen
  In order to bulk create promotion codes
  An administrator and a booth rep
  Should be able to maintain the system's promotion codes
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain promotions
  When I create a promotion "Julians Awesome Videos"
  Then I expect to have a promotion "Julians Awesome Videos"
  
  When I generate promotion codes with template "TESTINGCODE0000"
  Then I expect to see the system message "99 codes generated."
   And I expect to see 0 used 0 reserved 99 total promotion codes
   And I expect to have a promotion code "TESTINGCODE0001"

  When I generate promotion codes
  Then I expect to see the system message "99 codes generated."
   And I expect to see 0 used 0 reserved 198 total promotion codes
  