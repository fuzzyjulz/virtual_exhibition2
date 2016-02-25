Feature: Booth
  In order to provide visitors with content dierctly from a sponsor
  A visitor
  Should be able to view a sponsor's booth
  In order to generate income and interest in the sponsor
  
Background:
  Given a basic public event
  
Scenario: Can follow the Company Website url
  When I click through to the "All Content v2" booth
   And I click on the booth's company website button
  Then I expect to be at the url "http://marcs.org.au/"

