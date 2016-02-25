Feature: Make sure visitors can't edit a template
  In order to ensure that users don't have access to the template admin
  A visitor
  Should not have access to the template admin
  In order to protect the system from abuse
  
Background:
  Given a basic event
  
@visitor_logged_in
Scenario: Visitor should not have access to template admin
  When I open the template list
  Then I expect to not be allowed access
  When I edit an template
  Then I expect to not be allowed access
  
@booth_rep_logged_in
Scenario: Booth Reps should not have access to view template admin
  When I open the template list
  Then I expect to not be allowed access
  When I edit an template
  Then I expect to not be allowed access

@producer_logged_in
Scenario: Producers should not have access to view template admin
  When I open the template list
  Then I expect to not be allowed access
  When I edit an template
  Then I expect to not be allowed access

@admin_logged_in
Scenario: Admins should have access to template admin
  When I open the template list
  Then I expect to be allowed access
  When I edit an template
  Then I expect to be allowed access
