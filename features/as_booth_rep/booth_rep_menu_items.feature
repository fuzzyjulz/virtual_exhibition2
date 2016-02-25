Feature: Booth Rep menu links to the correct pages
  In order to navigate to the pages in the system
  A Booth Rep
  Should be able to use the menu bar
  In order to provide a similar feel as visitors get.

Background:
  Given a basic event
    And I am logged in as a booth rep with a booth
  
Scenario: Booth Rep can access all parts of the system via the menu
  When I click on the "Dashboard" menu item
  Then I see the booth rep dashboard
   And I expect to see the "Dashboard" menu item
   And I expect to not see the "Main Hall, Knowledge Center Tags List, Exhibition Hall" menu items
     
  When I click on the "Main Hall" menu item
  Then I expect to see the Main Hall
   And I expect the "Main Hall" menu item to be selected
   And I expect to see the "Dashboard, Main Hall, Knowledge Center Tags List, Exhibition Hall" menu items

  When I click on the "Knowledge Center Tags List" menu item
  Then I expect to see all knowledge center tags 
   And I expect the "Knowledge Center Tags List" menu item to be selected
   And I expect to see the "Dashboard, Main Hall, Knowledge Center Tags List, Exhibition Hall" menu items
   
  When I click on the "Exhibition Hall" menu item
  Then I expect to see the exhibitor hall
   And I expect the "Exhibition Hall" menu item to be selected
   And I expect to see the "Dashboard, Main Hall, Knowledge Center Tags List, Exhibition Hall" menu items

  When I click through to the "All Content" booth
  Then I expect to see the booth
   And I expect the "Exhibition Hall" menu item to be selected
   And I expect to see the "Dashboard, Main Hall, Knowledge Center Tags List, Exhibition Hall" menu items

  When I click through to the knowledge library
  Then I expect to see the knowledge library
   And I expect the "Exhibition Hall" menu item to be selected
   And I expect to see the "Dashboard, Main Hall, Knowledge Center Tags List, Exhibition Hall" menu items
