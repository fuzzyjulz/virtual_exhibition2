Feature: Users should be able to sign up for an event
  In order to give access to an event
  A visitor
  Should be able to sign up to a private event and view content
  In order to generate traffic through the site and provide details to be able to market booths to sponsors

Background:
  Given a basic event


Scenario: A new visitor signs up to an event
  When I register for the event
   And I confirm my email account
  Then I expect to see the Main Hall
   And I expect to be logged in
  
  When I open the home page
  Then I expect to see the Main Hall
  
  When I view the user details
  Then I expect to see the direct user details
  
  When I log out
  Then I expect to not be logged in
  
  When I login using the direct user credentials
  Then I expect to be logged in
  
  When I view the user details
  Then I expect to see the direct user details


Scenario: A new visitor signs up to an event with linkedin
  When I register for the event with linkedin
  Then I expect to see the Main Hall
   And I expect to be logged in
  
  When I open the home page
  Then I expect to see the Main Hall
  
  When I view the user details
  Then I expect to see the linkedin user details
  
  When I log out
  Then I expect to not be logged in

  When I login using linkedin
  Then I expect to be logged in
  
  When I view the user details
  Then I expect to see the linkedin user details


Scenario: A new visitor signs up to an event with linkedin, but linkedin returns almost no info
  When I register for the event with linkedin returning no details
  Then I expect to see the user registration page


Scenario: A new visitor signs up to an event with facebook
  When I register for the event with facebook
  Then I expect to see the Main Hall
   And I expect to be logged in
  
  When I open the home page
  Then I expect to see the Main Hall
  
  When I view the user details
  Then I expect to see the facebook user details
  
  When I log out
  Then I expect to not be logged in

  When I login using facebook
  Then I expect to be logged in
  
  When I view the user details
  Then I expect to see the facebook user details


Scenario: A new visitor signs up to an event with facebook, but facebook returns almost no info
  When I register for the event with facebook returning no details
  Then I expect to see the user registration page
