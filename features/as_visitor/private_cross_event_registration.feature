Feature: Users should be able to sign up for multiple events
  In order to access event content
  A visitor
  Should be able to sign up to a private event and then use the same credentials to sign into another event
  In order to make the use of the site(s) easier

Background:
  Given a basic event
    And a second basic event


Scenario: A visitor signs up to an event and then tries to sign into the second event
  When I register for the event
   And I confirm my email account
  Then I expect to see the Main Hall
   And I expect to be logged in
   And I expect to see the "First Event" event
   And I expect the user to only be assigned events:
      | First Event |
  When I log out
  Then I expect to not be logged in
   
  When I switch the current event to "Second Event"
   And I login using the direct user credentials
  Then I expect to see the Main Hall
   And I expect to be logged in
   And I expect to see the "Second Event" event
   And I expect the user to only be assigned events:
      | First Event |
      | Second Event |
  When I log out
  Then I expect to not be logged in

Scenario: A visitor signs up to an event and then tries to register for the second event
  When I register for the event
   And I confirm my email account
  Then I expect to see the Main Hall
   And I expect to be logged in
   And I expect to see the "First Event" event
   And I expect the user to only be assigned events:
      | First Event |
  When I log out
  Then I expect to not be logged in
   
  When I switch the current event to "Second Event"
   And I register for the event
  Then I expect to see the user registration page
  When I open the home page
  Then I expect to not be logged in
   
Scenario: A visitor goes to an event, but no events are recorded for the url or the event is not live
  When I switch the current event to be nothing
   And I open the home page
  Then I expect to not be logged in
   And I expect to be on the event dashboard page
   And I expect to see no events

  When I switch the current event to "First Event"
   And I open the home page
  Then I expect to not be logged in
   And I expect to be on the sign in page
   And I expect to be able to register
  When I mark the event "First Event" as closed
   And I open the home page
  Then I expect to not be logged in
   And I expect to be on the sign in page
   And I expect to not be able to register

Scenario: A visitor is given a sign up link to an event, but no events are recorded for the url or the event is not live
  When I switch the current event to be nothing
   And I open the sign up page for event "First Event"
  Then I expect to not be logged in
   And I expect to be on the event dashboard page
   And I expect to see no events

  When I switch the current event to "First Event"
   And I open the sign up page for event "First Event"
  Then I expect to see the user registration page
  
  When I mark the event "First Event" as closed
   And I open the sign up page for event "First Event"
  Then I expect to not be logged in
   And I expect to be on the sign in page
   And I expect to not be able to register
