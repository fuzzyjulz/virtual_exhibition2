When(/^I open the content list$/i) do
  list_contents
end

When(/^I edit content$/i) do
  @content = Content.first if @content.nil?
  visit(edit_content_path(@content.id))
end

When(/^I own the content$/i) do
  @content.owner_user = @current_user
  @content.save!
end

Then(/^I create a[n]? (\w+ content) item "(.*?)" for (id|file) "(.*?)"$/i) do |contentType, contentName, idOrFile, idFileLink|
  event = Event.first
  parameters = {name: contentName, content_type: contentType}

  case contentType
    when :youtube_video, :vimeo_video, :wistia_video, :slideshare
      parameters[:external_id] = idFileLink
    when :resource
      parameters[:resource_file] = idFileLink
    when :image
      parameters[:thumbnail_image] = idFileLink
  end

  @content = create_content(event, parameters)
  puts @content.to_json
  assert(@content.present?)
end

Then(/^I expect to( not)? have a[n]? (\w+ content) item "(.*?)"$/i) do |notAllowed, contentType, contentName|
  if !notAllowed
    view_content_item_by_name(contentName)
    assert(page.has_content?(contentName))
    has_content(notAllowed, contentType)
  else
    assert(!page.has_content?(contentName))
  end
end

Then(/^I expect the content to( not)? be valid$/i) do |notAllowed|
  view_content_item_by_name(@content.name)
  assert(notAllowed ^ !page.has_content?("Content is not valid,"))
end

Then(/^I expect the video duration to( not)? be "(.*?)"$/i) do |notAllowed, duration|
  view_content_item_by_name(@content.name)
  within(".duration") {assert(notAllowed ^ page.has_content?(duration))}
end

Then(/^I view the content item$/i) do ||
  assert(@content.present?)
  view_content_item_by_name(@content.name)
end

Then(/^I update the title of the content item to "(.*?)"$/i) do |contentName|
  list_contents
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{@content.name}']") {click_on "Edit"}
  
  fill_in "content_name", with: contentName
  click_on "Update Content"
  report_errors {@content}
  @content.name = contentName
end

Then(/^I delete the content item "(.*?)"$/i) do |contentName|
  list_contents
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{contentName}']") {click_on "Delete"}
end

Then(/^I expect to( not)? see (?!the)(\w+ content)$/i) do |notAllowed, contentType|
  has_content(notAllowed, contentType)
end

Then(/^I expect to( not)? see the (\w+ content)$/i) do |notAllowed, contentType|
  objectContentType = @content.content_type_code
  assert(objectContentType == contentType, "The content type wasn't the expected content type")
  has_content(notAllowed, contentType)
end

Then(/^I expect to see the content details( for content "(.*?)")?$/i) do |content_sect, content_name|
  @content = Content.find_by(name: content_name) if content_name.present?
  
  assert(@content.present?)
  assert(page.has_content?(@content.name))
  assert(page.has_content?(@content.short_desc)) if @content.short_desc
  assert(page.has_content?(@content.description)) if @content.description
  assert(page.has_content?("Sponsored By")) if @content.sponsor_booth_id
end

Transform /^\w+ content$/ do |contentTypeStr|
  contentTypeStr = /^(\w+)/.match(contentTypeStr)[1]
  contentTypeSym = nil
  case contentTypeStr
  when "video"
    contentTypeSym = :youtube_video
  when "vimeo"
    contentTypeSym = :vimeo_video
  when "wistia"
    contentTypeSym = :wistia_video
  when "presentation"
    contentTypeSym = :slideshare
  when "resource"
    contentTypeSym = :resource
  when "image"
    contentTypeSym = :image
  end
  assert(!contentTypeSym.nil?, "#{contentTypeStr} is not supported")
  contentTypeSym
end

module ContentHelpers
  def has_content(notAllowed, contentType)
    elements = nil
    case contentType
      when :youtube_video
        elements = page.all(:xpath, "//iframe[starts-with(@src,'//www.youtube.com/embed/')]")
      when :vimeo_video
        elements = page.all(:xpath, "//iframe[starts-with(@src,'//player.vimeo.com/video/')]")
      when :wistia_video
        elements = page.all(:xpath, "//iframe[starts-with(@src,'//fast.wistia.net/embed/iframe/')]")
      when :slideshare
        elements = page.all(:xpath, "//iframe[starts-with(@src,'//www.slideshare.net/slideshow/embed_code/')]")
      when :resource
        elements = page.all(:xpath, "//div[@class='contentMediaDisplay']/a[@class='contentDownloadButton']")
      when :image
        elements = page.all(:xpath, "//div[@class='contentMediaDisplay']/img")
    end
    
    assert(!elements.nil?, "#{contentType} is not supported")
    
    assert(elements.size > 0) if ! notAllowed
    assert(elements.size == 0) if notAllowed
  end
  
  def get_content_for_link(contentList, link)
    contentInDb = nil
    contentList.each {|content| contentInDb = content if preview_content_path(content) == link}
    contentInDb
  end
  
  def create_content(event, options)
      if @current_user.has_role?(:booth_rep)
        visit(events_dashboard_path)
        click_on "Content"
        click_on "New Content"
      else
        open_event(event)
        
        click_on "Create content"
      end
      prefix = "content_"
      fill_in "#{prefix}name", with: options[:name]
      select Content::CONTENT_TYPE[options[:content_type]], from: "#{prefix}content_type" if options[:content_type]
      select Privacy[options[:privacy]].label, from: "#{prefix}privacy" if options[:privacy]

      include_hidden_fields do
        within(:xpath, '//div[@content_type="resource"]') {fill_in "#{prefix}external_id", with: options[:external_id]} if options[:external_id]
        within(:xpath, '//div[@content_type="image"]') {attach_file("content_thumbnail_image_attributes_assets", "features/testfiles/#{options[:thumbnail_image]}")} if options[:thumbnail_image]
        within(:xpath, '//div[@content_type="resource"]') {attach_file("content_resource_file", "features/testfiles/#{options[:resource_file]}")} if options[:resource_file]
      
        click_button "Create Content"
      end
      report_errors { Content.find_by(name: options[:name]) }
    end
  
  def list_contents()
    if @current_user.has_role?(:visitor)
      visit(event_contents_path(Event.first))
    elsif @current_user.has_role?(:booth_rep)
      visit(events_dashboard_path)
      within ("#managebooth") {click_on "Content"}
    else
      open_event(Event.first)
      click_on("List contents")
    end
  end
  
  def view_content_item_by_name(contentName)
    list_contents
    page.within(:xpath, "//div[@id='content']//table//tr[td//text()='#{contentName}']") {click_on "View"}
  end
end

World(ContentHelpers)
