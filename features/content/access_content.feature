Feature: Make sure visitors can't edit a piece of content
  In order to ensure that users don't have access to the content admin
  A visitor
  Should not have access to the content admin
  In order to protect the system from abuse
  
Background:
  Given a basic event
    And I own all booths
  
@visitor_logged_in
Scenario: Visitor should not have access to content admin
  When I open the content list
  Then I expect to not be allowed access
  When I edit content
  Then I expect to not be allowed access
  When I own the content
   And I edit content
  Then I expect to not be allowed access
  
@booth_rep_logged_in
Scenario: Booth Reps should have access to view event admin
  When I open the content list
  Then I expect to be allowed access
  When I edit content
  Then I expect to not be allowed access
  When I own the content
   And I edit content
  Then I expect to be allowed access

@producer_logged_in
Scenario: Producers should have access to view event admin
  When I open the content list
  Then I expect to be allowed access
  When I edit content
  Then I expect to be allowed access

@admin_logged_in
Scenario: Admins should have access to content admin
  When I open the content list
  Then I expect to be allowed access
  When I edit content
  Then I expect to be allowed access
