Feature: Promotion Codes can be exported from the promotion screen
  In order to review promotion codes
  An administrator and a booth rep
  Should be able to maintain the system's promotion codes
  
Background:
  Given a basic event
  
Scenario: Admins should be able to maintain promotions
  When I log in as the event admin
   And I view a promotion
  
  Then I expect to see 0 used 0 reserved 1 total promotion codes

  When I export promotion codes
  Then I expect the promotion code export to contain "No records found."

  When I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart

   And I view a promotion
   And I expect to see 0 used 1 reserved 1 total promotion codes
   And I export promotion codes
  Then I expect the promotion code export to contain "No records found."

  When I click through to the main hall
   And I redeem my deals
   And I view a promotion
   And I expect to see 1 used 0 reserved 1 total promotion codes
   And I export promotion codes
  Then I expect the promotion code export to not contain "No records found."
   And I expect the promotion code export to contain "FS1000,Admin,User,test_admin@commstrat.com,"
   And I expect the promotion code export to not contain "Free Stuff,FS1000,Admin,User,test_admin@commstrat.com,"
   And I expect the promotion code export to not contain "All Content v2,Free Stuff,FS1000,Admin,User,test_admin@commstrat.com,"
   
When I export promotion codes for booth "All Content v2"
  Then I expect the promotion code export to not contain "No records found."
   And I expect the promotion code export to contain "Free Stuff,FS1000,Admin,User,test_admin@commstrat.com,"
   And I expect the promotion code export to not contain "All Content v2,Free Stuff,FS1000,Admin,User,test_admin@commstrat.com,"

When I export promotion codes for booth "All Content"
  Then I expect the promotion code export to contain "No records found."
   And I expect the promotion code export to not contain "Free Stuff,FS1000,Admin,User,test_admin@commstrat.com,"

When I export promotion codes for event "First Event"
  Then I expect the promotion code export to not contain "No records found."
   And I expect the promotion code export to contain "All Content v2,Free Stuff,FS1000,Admin,User,test_admin@commstrat.com,"
