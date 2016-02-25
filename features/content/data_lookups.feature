Feature: Users should be able to go to provided data extraction urls
  In order to ensure that the system still works as expected

Background:
  Given a basic event

@admin_logged_in
Scenario: A visitor goes to an event, but no events are recorded for the url or the event is not live
  When I visit "/events/#{@event.id}/contents.json"
  Then I expect to see the text:
    |All Content: YouTube Video|
    |All Content: Private Unfeatured YouTube Video|
    |All Content: Public YouTube Video|
    |All Content: Private Unfeatured Wistia Video|
    |All Content: Private Unfeatured Vimeo Video|
    |All Content: Slideshare Presentation|
    |All Content: Local Resource|
    |All Content: Remote Resource|
    |All Content: Image|
    |Knowledge Center: YouTube Video|
    |Knowledge Center: Private Unfeatured YouTube Video|
    |Knowledge Center: Public YouTube Video|
    |Knowledge Center: Private Unfeatured Wistia Video|
    |Knowledge Center: Private Unfeatured Vimeo Video|
    |Knowledge Center: Slideshare Presentation|
    |Knowledge Center: Local Resource|
    |Knowledge Center: Remote Resource|
    |Knowledge Center: Image|
