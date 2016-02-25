Feature: Make sure visitors can't edit a booth
  In order to ensure that users don't have access to the booth admin
  A visitor
  Should not have access to the booth admin
  In order to protect the system from abuse
  
Background:
  Given a basic event
  
@visitor_logged_in
Scenario: Visitor should not have access to booth admin
  When I open the booth list
  Then I expect to not be allowed access
  When I edit a booth
  Then I expect to not be allowed access
  
@booth_rep_logged_in
Scenario: Booth Reps should have access to view booth admin
  When I open the booth list
  Then I expect to be allowed access
  When I edit a booth
  Then I expect to not be allowed access
  When I own the booth
   And I edit a booth
  Then I expect to be allowed access

@producer_logged_in
Scenario: producers should have access to view booth admin
  When I open the booth list
  Then I expect to be allowed access
  When I edit a booth
  Then I expect to be allowed access

@admin_logged_in
Scenario: Admins should have access to booth admin
  When I open the booth list
  Then I expect to be allowed access
  When I edit a booth
  Then I expect to be allowed access
