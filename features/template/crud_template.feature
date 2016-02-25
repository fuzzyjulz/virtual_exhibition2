Feature: Allow template to be created, read, updated and deleted
  In order to administer the system's events
  An administrator
  Should be able to maintain the system's templates
  In order to easily maintain events
  
Background:
  Given a basic event
  
@admin_logged_in
Scenario: Admins should be able to maintain templates
  When I create a template "Second Booth Template"
  Then I expect to have a template "Second Booth Template"
  
  When I update the title of the template to "Awesome Booth Template" 
  Then I expect to not have a template "Second Booth Template"
  And  I expect to have a template "Awesome Booth Template"
  
  When I view the template
  Then I see the template details
  
  When I delete the template "Awesome Booth Template"
  Then I expect to not have a template "Awesome Booth Template"
  