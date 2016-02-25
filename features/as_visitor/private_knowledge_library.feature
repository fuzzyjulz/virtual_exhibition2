Feature: Knowledge Center
  In order to provide general informative content
  A visitor
  Should be able to view a "Knowledge Library" of general booths
  
Background:
  Given a basic event
  
@visitor_logged_in
Scenario: Visitor can access the knowledge library
  When I click through to the knowledge library
  Then I expect to see the knowledge library
   And I expect to see knowledge library content

@visitor_logged_in
Scenario: Visitor can preview a video
  When I click through to the knowledge library
  Then I can preview video content
   And I expect to see the content details 
   And I expect to see the video content
  
@visitor_logged_in
Scenario: Visitor can preview a presentation
  When I click through to the knowledge library
  Then I can preview presentation content
   And I expect to see the content details 
   And I expect to see the presentation content

@visitor_logged_in
Scenario: Visitor can preview a resource
  When I click through to the knowledge library
  Then I can preview resource content
   And I expect to see the content details 
   And I expect to see the resource content

@visitor_logged_in
Scenario: Visitor can preview an image
  When I click through to the knowledge library
  Then I can preview image content
   And I expect to see the content details 
   And I expect to see the image content
