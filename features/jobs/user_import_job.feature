Feature: Import users from a text file
  In order to easily creat bulk groups of users
  An admin
  Should be able to provide a user import file
  In order to save time/money entering in users manually
  
Background:
  Given a basic event
    And a second basic event
  
Scenario: Run the user import
  When I log in as the event admin
   And I run the user import job for the file "import_users.csv"
   And I expect to see "Records: 5, Saved: 3, New: 3, Updated: 0, Failed: 2"
  Then I expect to have 4 users of the system
   And I expect to have 2 users of the "First Event" event
   And I expect to have 2 users of the "Second Event" event
  
  When I run the user export job for the "First Event" event
  Then I expect to see users of the "First Event" event
   And I expect to not see users of the "Second Event" event only

  When I run the user export job for the "Second Event" event
  Then I expect to not see users of the "First Event" event only
   And I expect to see users of the "Second Event" event

  When I open the home page
   And I log out
   And I log in with email "julz.west+import2@gmail.com" and password "password1"
  Then I expect to not be logged in
  
  When I log in with email "julz.west+import3@gmail.com" and password "password2"
  Then I expect to not be logged in

  When I log in with email "Julz.West+1@gmail.com" and password "password1"
  Then I expect to not be logged in

  When I log in with email "Julz.West+1@gmail.com" and password "password"
  Then I expect to be logged in

  When I log out
   And I log in with email "julz.west+import4@gmail.com" and password "password4"
  Then I expect to be logged in
  