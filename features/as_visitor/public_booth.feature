Feature: Booths should be publically accessable
  An anonymous user
  Should have access to the public booth screen
  In order to drive through more traffic to the booths and sponsors
  
Background:
  Given a basic public event
  
Scenario: Anonymously I should be able to navigate to the Booth
  When I click through to the "All Content" booth
  Then I expect to see video content
   And I expect to see presentation content
   And I expect to not see resource content
   And I expect to see image content

  When I click through to the "All Content" booth
   And I click About Us
  Then I expect to see About Us content
  
  When I click through to the "All Content" booth
   And I click Booth Chat
  Then I expect to see the login popup

  When I click through to the "All Content" booth
   And I click Leave Business Card
  Then I expect to see the login popup

  When I click through to the "All Content" booth
   And I click Send Booth Message
  Then I expect to see the login popup

  When I click through to the "All Content" booth
   And I click Resources
  Then I expect to see the resource list

@visitor_logged_in
Scenario: Visitor can access the booth
  When I click through to the "All Content" booth
  Then I expect to see the booth
   And I expect to see video content
   And I expect to see presentation content
   And I expect to not see resource content
   And I expect to see image content

  When I click through to the "All Content" booth
   And I click About Us
  Then I expect to see About Us content
  
  When I click through to the "All Content" booth
   And I click Booth Chat
  Then I expect to see the booth chat screen

  When I click through to the "All Content" booth
   And I click Leave Business Card
  Then I expect to see the leave business card screen
  When I send the message "Hi, this is a test message"
  Then I expect to see the system message "Your business card has been sent to the booth owner"

  When I click through to the "All Content" booth
   And I click Send Booth Message
  Then I expect to see the send booth message screen
  When I send the message "Hi, this is a test message"
  Then I expect to see the system message "Your message has been sent to the booth owner."

  When I click through to the "All Content" booth
   And I click Resources
  Then I expect to see the resource list
