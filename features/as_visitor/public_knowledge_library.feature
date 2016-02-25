Feature: the Knowledge Center should be publically accessable
  An anonymous user
  Should have access to the public Knowledge Center screen
  In order to drive through more traffic to the booths and sponsors
  
Background:
  Given a basic public event
  
Scenario: Anonymous users can access the knowledge library
  When I click through to the knowledge library
  Then I expect to see the knowledge library
   And I expect to see knowledge library content

Scenario: Anonymous users can preview a video
  When I click through to the knowledge library
  Then I can preview video content for a featured item
   And I expect to see the content details 
   And I expect to see the video content
  
Scenario: Anonymous users can preview a presentation
  When I click through to the knowledge library
  Then I can preview presentation content for a featured item
   And I expect to see the content details 
   And I expect to see the presentation content

Scenario: Anonymous users can preview a video
  When I click through to the knowledge library
  Then I can preview video content for a not featured item
   And I expect to see the login popup

Scenario: Anonymous users can preview a video
  When I click through to the knowledge library
  Then I can preview video content for a publically listed item
   And I expect to see the content details 
   And I expect to see the video content

Scenario: Anonymous users can preview a video
  When I click through to the knowledge library
  Then I can preview video content for a privately listed item
   And I expect to see the login popup
