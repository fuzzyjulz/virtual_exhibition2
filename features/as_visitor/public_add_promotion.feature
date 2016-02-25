Feature: Add promotion to the cart
  In order to provide deals to the delegate
  A visitor
  Should add deals to their cart and redeem them
  In order to generate interest in the sponsor booths

Background:
  Given a basic public event


Scenario: A visitor adds a promotion to their cart and redeems it
  When I am logged in as a visitor
  When I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
   And I log out

  When I log in as the event admin
   And I view a promotion
  Then I expect to see 0 used 1 reserved 1 total promotion codes
   And I log out

  When I am logged in as a visitor
   And I redeem my deals
   And I log out

  When I log in as the event admin
   And I view a promotion
  Then I expect to see 1 used 0 reserved 1 total promotion codes



Scenario: An anonymous vistor adds a promotion to their cart and then is forced to sign in to redeem
  When I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart

  When I log in as the event admin
   And I create a promotion code "PROMO001"
   And I view a promotion
  Then I expect to see 0 used 1 reserved 2 total promotion codes
   And I log out

  Then I expect to have an empty cart

  When I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
  Then I expect to not have an empty cart

  When I am logged in as a visitor
  Then I expect to not have an empty cart
   And I redeem my deals
  Then I expect to have an empty cart
   And I log out

  When I log in as the event admin
   And I view a promotion
  Then I expect to see 1 used 1 reserved 2 total promotion codes



Scenario: A visitor's cart can be stored and reloaded across sessions
  When I am logged in as a visitor
   And I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
   And I log out

  When I log in as the event admin
   And I view a promotion
  Then I expect to see 0 used 1 reserved 1 total promotion codes
   And I log out
   
   And I clear my browser cookies

  When I am logged in as a visitor
   And I redeem my deals
   And I log out

  When I log in as the event admin
   And I view a promotion
  Then I expect to see 1 used 0 reserved 1 total promotion codes



Scenario: A visitor's cart can be stored and merged with an existing cart.
  When I am logged in as a visitor
   And I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
   And I log out

  When I log in as the event admin
   And I view a promotion
  Then I expect to see 0 used 1 reserved 1 total promotion codes
  When I create a promotion code "PROMO001"
   And I view a promotion
  Then I expect to see 0 used 1 reserved 2 total promotion codes
  
  When I create a booth "Awesome Productions" using parameters
    |template_name|Booth Template v2|
   And I create a promotion "Awesome Stuff 10% off"
  When I create a promotion code "AS001"
   And I view the "Awesome Stuff 10% off" promotion
  Then I expect to see 0 used 0 reserved 1 total promotion codes
   And I log out
   
   And I clear my browser cookies

  When I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
   And I click through to the "Awesome Productions" booth
   And I add the booth deal to my cart
   And I am logged in as a visitor
  Then I log out
  
  When I log in as the event admin
   And I view the "Free Stuff" promotion
  Then I expect to see 0 used 1 reserved 2 total promotion codes
   And I view the "Awesome Stuff 10% off" promotion
  Then I expect to see 0 used 1 reserved 1 total promotion codes
   And I log out

Scenario: Customers with a redeemed deal should not be able to redeem the same deal again
  When I am logged in as a visitor
   And I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
   And I redeem my deals
   And I log out

  When I log in as the event admin
   And I view a promotion
   And I create a promotion code "PROMO001"
   And I view a promotion
  Then I expect to see 1 used 0 reserved 2 total promotion codes
   And I log out

   And I clear my browser cookies

  When I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
 
  When I am logged in as a visitor
  Then I expect to have an empty cart
   And I log out
  
  When I log in as the event admin
   And I view a promotion
  Then I expect to see 1 used 0 reserved 2 total promotion codes
   And I log out

Scenario: A visitor can remove items from their cart
  When I am logged in as a visitor
   And I visit the home page
   And I click through to the "All Content v2" booth
   And I add the booth deal to my cart
   And I log out

  When I log in as the event admin
   And I view a promotion
  Then I expect to see 0 used 1 reserved 1 total promotion codes
   And I log out

  When I am logged in as a visitor
   And I view my cart
  
  Then I expect to see "Free Stuff"
  
  When I remove the deal "Free Stuff" from my cart
  Then I expect to not see "Free Stuff"
   And I log out

  When I log in as the event admin
   And I view a promotion
  Then I expect to see 0 used 0 reserved 1 total promotion codes
   And I log out
