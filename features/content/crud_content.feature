Feature: Allow contents to be created, read, updated and deleted
  In order to administer the system's events
  An administrator and a booth rep
  Should be able to maintain the system's contents
  In order to easily maintain events
  
Background:
  Given a basic event
    And I own all booths
  
@admin_logged_in
Scenario: Admins should be able to maintain events
  When I create a video content item "Julians Awesome Video" for id "k6rO_LXk9ko"
  Then I expect to have a video content item "Julians Awesome Video"
  
  When I update the title of the content item to "Julians Amazeballs Video" 
  Then I expect to not have a video content item "Julians Awesome Video"
  And  I expect to have a video content item "Julians Amazeballs Video"
  
  When I view the content item
  Then I expect to see the content details
  
  When I delete the content item "Julians Amazeballs Video"
  Then I expect to not have a video content item "Julians Amazeballs Video"

@admin_logged_in
Scenario: Admins should be able to create all content types
  When I create a video content item "Julians Awesome Video" for id "k6rO_LXk9ko"
  Then I expect to have a video content item "Julians Awesome Video"

  When I create a presentation content item "Julians Awesome Presentation" for id "31194963"
  Then I expect to have a presentation content item "Julians Awesome Presentation"

  When I create an image content item "Julians Awesome Picture" for file "info.png"
  Then I expect to have an image content item "Julians Awesome Picture"

  When I create a resource content item "Julians Awesome File" for file "golden_brown.docx"
  Then I expect to have a resource content item "Julians Awesome File"

@booth_rep_logged_in
Scenario: Booth Reps should be able to maintain events
  When I create a video content item "Julians Awesome Video" for id "k6rO_LXk9ko"
  Then I expect to have a video content item "Julians Awesome Video"
  
  When I update the title of the content item to "Julians Amazeballs Video" 
  Then I expect to not have a video content item "Julians Awesome Video"
  And  I expect to have a video content item "Julians Amazeballs Video"
  
  When I view the content item
  Then I expect to see the content details
  
  When I delete the content item "Julians Amazeballs Video"
  Then I expect to not have a video content item "Julians Amazeballs Video"

@booth_rep_logged_in
Scenario: Booth Reps should be able to create all content types
  When I create a video content item "Julians Awesome Video" for id "k6rO_LXk9ko"
  Then I expect to have a video content item "Julians Awesome Video"
   And I expect the content to be valid
   And I expect the video duration to be "4:56"

  When I create a wistia content item "Julians Awesome Wistia Video" for id "fe8t32e27x"
  Then I expect to have a wistia content item "Julians Awesome Wistia Video"
   And I expect the content to be valid
   And I expect the video duration to be "1:13"

  When I create a vimeo content item "Julians Awesome Vimeo Video" for id "76979871"
  Then I expect to have a vimeo content item "Julians Awesome Vimeo Video"
   And I expect the content to be valid
   And I expect the video duration to be "1:02"

  When I create a presentation content item "Julians Awesome Presentation" for id "31194963"
  Then I expect to have a presentation content item "Julians Awesome Presentation"
   And I expect the content to be valid

  When I create an image content item "Julians Awesome Picture" for file "info.png"
  Then I expect to have an image content item "Julians Awesome Picture"
   And I expect the content to be valid

  When I create a resource content item "Julians Awesome File" for file "golden_brown.docx"
  Then I expect to have a resource content item "Julians Awesome File"
   And I expect the content to be valid
