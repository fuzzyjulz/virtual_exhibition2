Feature: Make sure visitors can't edit a event
  In order to ensure that users don't have access to the event admin
  A visitor
  Should not have access to the event admin
  In order to protect the system from abuse
  
Background:
  Given a basic event
  
@visitor_logged_in
Scenario: Visitor should not have access to event admin
  #When I open the event list
  #Then I expect to not be allowed access
  When I edit a event
  Then I expect to not be allowed access
  
@booth_rep_logged_in
Scenario: Booth Reps should have access to view event admin
  #When I open the event list
  #Then I expect to be allowed access
  When I edit a event
  Then I expect to not be allowed access

@producer_logged_in
Scenario: producers should have access to view event admin
  #When I open the event list
  #Then I expect to be allowed access
  When I edit a event
  Then I expect to be allowed access

@admin_logged_in
Scenario: Admins should have access to event admin
  #When I open the event list
  #Then I expect to be allowed access
  When I edit a event
  Then I expect to be allowed access
