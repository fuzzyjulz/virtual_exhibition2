Feature: Make sure visitors can't edit a product
  In order to ensure that users don't have access to the product admin
  A visitor
  Should not have access to the event admin
  In order to protect the system from abuse
  
Background:
  Given a basic event
  
@visitor_logged_in
Scenario: Visitor should not have access to product admin
  When I open the product list
  Then I expect to not be allowed access
  When I edit a product
  Then I expect to not be allowed access
  
@booth_rep_logged_in
Scenario: Booth Reps should have access to product admin
  When I open the product list
  Then I expect to be allowed access
  When I edit a product
  Then I expect to not be allowed access
  When I own the booth
   And I edit a product
  Then I expect to be allowed access

@producer_logged_in
Scenario: Producers should have access to product admin
  When I open the product list
  Then I expect to be allowed access
  When I edit a product
  Then I expect to be allowed access

@admin_logged_in
Scenario: Admins should have access to product admin
  When I open the product list
  Then I expect to be allowed access
  When I edit a product
  Then I expect to be allowed access
