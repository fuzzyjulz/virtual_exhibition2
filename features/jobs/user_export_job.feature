Feature: Generate a user export
  In order to provide information about the users for each and all events internally
  An admin
  Should be able to generate the export
  In order to give information to potential sponsors in order to aide the sales process, and market to existing users
  
Background:
  Given a basic event
    And a second basic event
    And I am logged in as a admin
    And I create a visitor user "Doe, John" with email "john.doe.test@commstrat.com"
    And I add the user to the "First Event" event
    And I create a visitor user "Doe, Jane" with email "jane.doe.test@commstrat.com"
    And I add the user to the "Second Event" event
    And I log out


Scenario: Run the user export
  When I log in as the event admin
   And I run the user export job for all events
  Then I expect to see users of the system
   And I expect to see users of the "First Event" event
   And I expect to see users of the "Second Event" event
  
Scenario: Run the user export for each event
  When I log in as the event admin
   And I run the user export job for the "First Event" event
  Then I expect to see users of the "First Event" event
   And I expect to not see users of the "Second Event" event only

  When I run the user export job for the "Second Event" event
  Then I expect to not see users of the "First Event" event only
   And I expect to see users of the "Second Event" event
