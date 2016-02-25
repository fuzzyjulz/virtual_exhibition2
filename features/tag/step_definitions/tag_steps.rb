When(/^I open the tag list$/i) do
  list_tags
end

When(/^I edit a tag$/i) do
  @tag = Tag.first if @tag.nil?
  visit(edit_tag_path(@tag.id))
end

Then(/^I create a tag "(.*?)"$/i) do |tagName|
  event = Event.first
  parameters = {name: tagName, tag_type: :topic}

  @tag = create_tag(event, parameters)
  puts @tag.to_json
  assert(@tag.present?)
end

Then(/^I expect to( not)? have a tag "(.*?)"$/i) do |notAllowed, tagName|
  list_tags
  assert(notAllowed.present? ^ page.has_content?(tagName))
end

Then(/^I view the tag$/i) do ||
  assert(@tag.present?)
  view_tag_by_name(@tag.name)
end

Then(/^I update the title of the tag to "(.*?)"$/i) do |tagName|
  list_tags
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{@tag.name}']") {click_on "Edit"}
  
  fill_in "tag_name", with: tagName
  click_on "Update Tag"
  report_errors {@tag}
  @tag.name = tagName
end

Then(/^I delete the tag "(.*?)"$/i) do |tagName|
  list_tags
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{tagName}']") {click_on "Delete"}
end

Then(/^I expect to( not)? see the tag details$/i) do |notAllowed|
  assert(@tag.present?)
  assert(notAllowed.present? ^ page.has_content?("View Tag"))
  assert(notAllowed.present? ^ page.has_content?(@tag.name))
end

module TagHelpers
  def create_tag(event, options)
    open_event(event)
    
    click_on "Create tag"
    prefix = "tag_"
    fill_in "#{prefix}name", with: options[:name]
    select Tag::TAG_TYPE[options[:tag_type]], from: "tag_tag_type" if options[:tag_type]

    click_button "Create Tag"
    report_errors { Tag.find_by(name: options[:name]) }
  end
  
  def list_tags()
    if @current_user.has_role?(:visitor) or @current_user.has_role?(:booth_rep)
      visit(event_tags_path(Event.first))
    else
      open_event(Event.first)
      click_on("List tags")
    end
  end
  
  def view_tag_by_name(tagName)
    list_tags
    page.within(:xpath, "//div[@id='content']//table//tr[td//text()='#{tagName}']") {click_on "View"}
  end
end

World(TagHelpers)
