Feature: Booths should be publically accessable
  An anonymous user
  Should have access to the public booth screen
  In order to drive through more traffic to the booths and sponsors
  
Background:
  Given a basic public event
  When I am logged in as an admin
   And I create a booth "Booth v2" using parameters
    |template_name|Booth Template v2|
    |contents|Knowledge Center: YouTube Video,Knowledge Center: Private Unfeatured Wistia Video,Knowledge Center: Private Unfeatured Vimeo Video,Knowledge Center: Slideshare Presentation,Knowledge Center: Local Resource,Knowledge Center: Image|
   And I log out
  
Scenario: Anonymously I should be able to navigate to the Booth
  When I click through to the "Booth v2" booth
  Then I expect to see video content
   And I expect to see presentation content
   And I expect to not see resource content
   And I expect to see image content

  When I click through to the "All Content" booth
   And I click Leave Business Card
  Then I expect to see the login popup

Scenario: Visitor can access the booth
  When I am logged in as a visitor
   And I click through to the "All Content v2" booth
  Then I expect to see the booth
   And I expect to see video content
   And I expect to see presentation content
   And I expect to not see resource content
   And I expect to see image content

  When I click through to the "All Content v2" booth
   And I click Leave Business Card
  Then I expect to see the leave business card screen
  When I send the message "Hi, this is a test message"
  Then I expect to see the system message "Your business card has been sent to the booth owner"
