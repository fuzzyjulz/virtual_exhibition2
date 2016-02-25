Feature: Make sure that users of the system can login
  A visitor an administrator and a booth rep
  Should have access to the system after login
  In order to provide authenticated conent to the user and capture their details

Background:
  Given a basic event
  
Scenario: Visitor should be able to login
  When I open the home page
  Then I expect to not be logged in
  When I am logged in as a visitor
  Then I expect to be logged in
  Then list users
  
Scenario: Admin should be able to login
  When I open the home page
  Then I expect to not be logged in
  When I am logged in as an admin
  Then I expect to be logged in
  Then list users
    
Scenario: Booth Rep should be able to login
  When I open the home page
  Then I expect to not be logged in
  When I am logged in as a booth rep
  Then I expect to be logged in
  Then list users