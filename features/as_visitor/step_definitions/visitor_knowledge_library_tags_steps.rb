When(/^I click through to the knowledge library categories$/i) do
  open_knowledge_lib_tags()
end

When(/^I click on a tag$/i) do
  kcTags = page.all(:xpath, "//a[contains(@class,'tagListItem')]")
  assert(kcTags.present?)
  kcTags.first.click
  tag_id = /tag=(\d+)$/.match(kcTags.first[:href])[1]
  assert(tag_id.present?)
  @tag = Tag.find(tag_id)
  @hall = @event.knowledge_halls().first
end

Then(/^I expect to see (only|all) knowledge center tags$/i) do |onlyOrAll|
  tagList = []
  Tag.where(featured: true).each do |tag|
    hasKCContent = false
    tag.contents.each {|content| hasKCContent = true if content.halls.include?(@hall)}
    
    tagList << tag if hasKCContent
  end
  
  if (onlyOrAll.downcase == "all")
    tagList.each do |tag|
      assert(page.has_content?(tag.name), "Tag #{tag.name} not found.")
    end
  elsif (onlyOrAll.downcase == "only")
    page.all(".tagListItem").each do |tagItem|
      tagDescription = tagItem.find(".description").text
      
      hasInList = false
      tagList.each {|tag| hasInList = true if tag.name == tagDescription}
      assert(hasInList, "Tag #{tagDescription} not found in list")
    end
  end
end

module VisitorBoothHelpers
  def open_knowledge_lib_tags()
    if booth_rep_or_producer?
      click_on_visitor_menu @event.main_halls.first.name
    else 
      visit("/")
    end
    @hall = @event.knowledge_hall_tag_hall().first
    assert(@hall.present?)
    click_on "Browse #{@hall.name}"
    assert(page.has_content?(@hall.title)) if @hall.title.present?
    assert(page.has_content?(@hall.description)) if @hall.description.present?
    page.has_button?("View all content")
  end
end

World(VisitorBoothHelpers)
