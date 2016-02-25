Feature: Make sure visitors can't edit a promotion
  In order to ensure that users don't have access to the promotion admin
  A visitor
  Should not have access to the event admin
  In order to protect the system from abuse
  
Background:
  Given a basic event
  
@visitor_logged_in
Scenario: Visitor should not have access to promotion admin
  When I open the promotion list
  Then I expect to not be allowed access
  When I edit a promotion
  Then I expect to not be allowed access
  
Scenario: Booth Reps should have access to promotion admin
  When I am logged in as a booth rep with a booth
   And I open the promotion list
  Then I expect to be allowed access
  When I edit a promotion
  Then I expect to be allowed access

@producer_logged_in
Scenario: Producers should have access to promotion admin
  When I open the promotion list
  Then I expect to be allowed access
  When I edit a promotion
  Then I expect to be allowed access

@admin_logged_in
Scenario: Admins should have access to promotion admin
  When I open the promotion list
  Then I expect to be allowed access
  When I edit a promotion
  Then I expect to be allowed access
