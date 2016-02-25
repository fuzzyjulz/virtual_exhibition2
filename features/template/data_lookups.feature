Feature: Users should be able to go to provided data extraction urls
  In order to ensure that the system still works as expected

Background:
  Given a basic event

@admin_logged_in
Scenario: A visitor goes to an event, but no events are recorded for the url or the event is not live
  When I visit "/templates/template_sub_types/exhibitionHall.json"
  Then I expect to see the text:
      |Exhibition Hall - Booth List|
      |Exhibition Hall - Halls List|
      |Exhibition Hall - All Booth List|

  When I visit "/templates/template_sub_types/booth.json"
  Then I expect to see the text:
      |Booth - Hall Format|
      |Booth - Promotion format|

  When I visit "/templates/template_sub_types/mainHall.json"
  Then I expect to see the text:
      |Main Hall - v1|
      |Main Hall - v2|

  When I visit "/templates/template_sub_types/knowledgeLibraryHall.json"
  Then I expect to see the text:
      |Knowledge Center - Knowledge Library|
      |Knowledge Center - Tag List|
      
  When I visit "/templates/template_sub_types/noHall.json"
  Then I expect to see get the content "{}"
      