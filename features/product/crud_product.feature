Feature: Allow products to be created, read, updated and deleted
  In order to administer the system's events
  An administrator and a booth rep
  Should be able to maintain the system's products
  In order to easily maintain events
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain products
  When I create a product "Stuff"
  Then I expect to have a product "Stuff"
  
  When I update the title of the product to "Nonsense" 
  Then I expect to not have a product "Stuff"
  And  I expect to have a product "Nonsense"
  
  When I view the product
  Then I expect to see the product details
  
  When I delete the product "Nonsense"
  Then I expect to not have a product "Nonsense"
