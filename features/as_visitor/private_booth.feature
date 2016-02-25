Feature: Booth
  In order to provide visitors with content dierctly from a sponsor
  A visitor
  Should be able to view a sponsor's booth
  In order to generate income and interest in the sponsor
  
Background:
  Given a basic event
  
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

  When I click through to the "All Content" booth
   And I click Send Booth Message
  Then I expect to see the send booth message screen

  When I click through to the "All Content" booth
   And I click Resources
  Then I expect to see the resource list

