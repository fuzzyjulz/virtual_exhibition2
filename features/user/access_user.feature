Feature: Make sure visitors can't edit or view another user
  In order to ensure that users don't have access to the user admin and can only view valid user information
  A visitor
  Should not have access to the user admin or private fields
  In order to protect the system from abuse
  
Background:
  Given a basic event
  
@visitor_logged_in
Scenario: Visitor should not have access to user admin
  When I open the user list
  Then I expect to not be allowed access
  When I edit a user
  Then I expect to not be allowed access
  When I view a user
  Then I expect to see fields: First name, Last name, Events, Booths, Industry, Topics
   And I expect to not see fields: Company, Email, Work phone
   And I expect to not see fields: Created at, Last sign in IP, Current sign in IP, Sign in count
  
@booth_rep_logged_in
Scenario: Booth Reps should have access to view user admin
  When I open the user list
  Then I expect to not be allowed access
  When I edit a user
  Then I expect to not be allowed access
  When I view a user
  Then I expect to see fields: First name, Last name, Events, Booths, Industry, Topics
   And I expect to see fields: Company, Email, Work phone
   And I expect to not see fields: Created at, Last sign in IP, Current sign in IP, Sign in count

@producer_logged_in
Scenario: Producers should have access to view user admin
  When I open the user list
  Then I expect to be allowed access
  When I open the user list JSON
  Then I expect to be allowed access
  When I edit a user
  Then I expect to not be allowed access
  When I view a user
  Then I expect to see fields: First name, Last name, Events, Booths, Industry, Topics
   And I expect to see fields: Company, Email, Work phone
   And I expect to not see fields: Created at, Last sign in IP, Current sign in IP, Sign in count
  When I create a producer user "Doe, John"
   And I edit the user
  Then I expect to be allowed access
  

@admin_logged_in
Scenario: Admins should have access to user admin
  When I open the user list
  Then I expect to be allowed access
  When I open the user list JSON
  Then I expect to be allowed access
  When I edit a user
  Then I expect to be allowed access
  When I view a user
  Then I expect to see fields: First name, Last name, Events, Booths, Industry, Topics
   And I expect to see fields: Company, Email, Work phone
   And I expect to see fields: Created at, Last sign in IP, Current sign in IP, Sign in count
  