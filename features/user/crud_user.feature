Feature: Allow User to be created, read, updated and deleted
  In order to administer the system's events
  An administrator
  Should be able to maintain the system's users
  In order to easily maintain users
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain users
  When I create a user "Doe, John"
  Then I expect to have a user "Doe, John"
   And I expect the user to be a visitor
   And I expect the user to not be a booth_rep
   And I expect the user to not be a admin
  
  When I update the user's first name to "Albert" 
  Then I expect to not have a user "Doe, John"
  And  I expect to have a user "Doe, Albert"
  
  When I view the user
  Then I see the user's details
  
  When I delete the user "Doe, Albert"
  Then I expect to not have a user "Doe, Albert"

@admin_logged_in
Scenario: Admins should be able to create visitor users
  When I create a visitor user "Doe, John"
  Then I expect to have a user "Doe, John"
   And I expect the user to be a visitor
   And I expect the user to not be a booth_rep
   And I expect the user to not be a admin

@admin_logged_in
Scenario: Admins should be able to create booth rep users
  When I create a booth_rep user "Doe, John"
  Then I expect to have a user "Doe, John"
   And I expect the user to not be a visitor
   And I expect the user to be a booth_rep
   And I expect the user to not be a admin

@admin_logged_in
Scenario: Admins should be able to create admin users
  When I create an admin user "Doe, John"
  Then I expect to have a user "Doe, John"
   And I expect the user to not be a visitor
   And I expect the user to not be a booth_rep
   And I expect the user to be a admin

Scenario: Producers should only be able to assign up to producer role
  When I am logged in as a producer
   And I edit the user "User, Testing"
   And I expect the user to not be a visitor
   And I expect the user to not be a booth_rep
   And I expect the user to not be a admin
   And I expect the user to be a producer
   And I expect the user's possible roles to be:
        |producer|
        |visitor|
        |booth_rep|
        |test_admin|

@admin_logged_in
Scenario: Visitors should be able to maintain their own user details
  When I create a visitor user "Doe, John" with email "visitor.test@commstrat.com.au"
  Then I expect to have a user "Doe, John"
  
  When I open the home page
   And I log out
   And I log in with email "visitor.test@commstrat.com.au" and password "Testing123"
   And I update my first name to "Albert" 
  Then I log out
   And I log in as the super admin
   And I expect to not have a user "Doe, John"
   And I expect to have a user "Doe, Albert"
