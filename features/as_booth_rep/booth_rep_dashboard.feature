Feature: Booth rep dashboard
  In order to provide booth reps with an easier experience
  A booth rep
  Should be able to view the customised booth rep dashboard
  In order to provide admin features on a booth
  
Background:
  Given a basic event
    And I am logged in as a booth rep with a booth
  
Scenario: Booth rep can access the booth rep dashboard
  Then I expect to be logged in
   And I see the booth rep dashboard
