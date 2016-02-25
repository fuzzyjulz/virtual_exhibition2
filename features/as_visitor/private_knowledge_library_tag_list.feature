Feature: Knowledge Center Tag Library
  In order to provide a more specific set of knowledge library content
  A visitor
  Should be able to view the types of tagged content, and filter this in the knowledge library
  
Background:
  Given a basic event
  
@visitor_logged_in
Scenario: Visitor can access the knowledge library categories
  When I click through to the knowledge library categories
  Then I expect to see all knowledge center tags 

@visitor_logged_in
Scenario: Visitor can access the knowledge library categories
  When I click through to the knowledge library categories
   And I click on a tag
  Then I expect to see the knowledge library
   And I expect to see knowledge library content
   And I expect to see only content assigned to the tag

@visitor_logged_in
Scenario: Visitor can change the tags selected
  When I click through to the knowledge library categories
   And I click on a tag
  Then I expect to see the knowledge library
   And I expect to see only content assigned to the tag
