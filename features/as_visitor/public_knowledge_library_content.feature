Feature: The Knowledge Center content should be publically accessable
  An anonymous user
  Should have access to the public Knowledge Center content screen
  In order to drive through more traffic to the booths and sponsors
  
Background:
  Given a basic public event
  
Scenario: Anonymous users can click through to the sponsor
  When I visit "/contents/#{@sponsored_content.id}/preview"
   And I click the content sponsored by button
  Then I expect to be on booth "All Content"