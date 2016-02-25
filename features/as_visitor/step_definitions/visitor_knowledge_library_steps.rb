When(/^I click through to the knowledge library$/i) do
  if booth_rep_or_producer?
    click_on_visitor_menu @event.main_halls.first.name
  else 
    visit("/")
  end
  if (@event.knowledge_hall_tag_hall().present?)
    open_knowledge_lib_tags
    click_on "View all content"
    @hall = @event.knowledge_halls().first
  else
    @hall = @event.knowledge_halls().first
    assert(@hall.present?)
    click_on_menu @hall.name
  end
end

When(/^I click the content sponsored by button$/i) do
  find(".sponsoredByLogo a").click
end

Then(/^I expect to see the knowledge library$/i) do ||
  find(".knowledgeCenter")
  assert(page.text.match(/Topics/))
  assert(page.text.match(/Featured/))
  assert(page.text.match(/Latest/))
  assert(page.text.match(/Browse All/))
  
  @hall = @event.knowledge_hall
end

Then(/^I expect to see knowledge library content$/i) do ||
  kcContents = page.all(:xpath, "//a[contains(@class,'knowledgevideo')]")
  assert(kcContents.size > 0, "Must have content")
end

Then(/^I expect to see only content assigned to the tag( "(.*?)")?$/i) do |tag_name_sect, tag_name|
  @tag = Tag.find_by(name: tag_name) if tag_name.present?
  
  kcContents = page.all(:xpath, "//a[contains(@class,'knowledgevideo')]")
  assert(kcContents.size > 0, "Must have content")
  kcContents.each do |content|
    contentInDb = get_content_for_link(@hall.contents, content[:href])
    assert(contentInDb.present?)
    assert(contentInDb.tags.include?(@tag))
  end
end

Then(/^I can preview (\w+ content)( for a( not)? (featured|publically listed|privately listed) item)?$/i) do |contentType, options, notAllowed, optionType|
  isAllowed = !notAllowed.present?

  click_link("Browse All")
  
  kcContents = nil
  possibleContents = @hall.contents
  publicPrivateOption = nil
  loop do
    if (optionType == "featured")
      kcContents = page.all(:xpath, "//a[contains(@class,'knowledgevideo') and contains(@class,'#{contentType}') and #{isAllowed ? "div//div[contains(@class,'featuredContent')]" : "not(div//div[contains(@class,'featuredContent')])" }]")
      possibleContents = possibleContents.where(featured: isAllowed)
    elsif (optionType == "publically listed" or optionType == "privately listed")
      if (optionType == "publically listed")
        publicPrivateOption = isAllowed ? :public_scope : :private_scope
      elsif (optionType == "privately listed")
        publicPrivateOption = isAllowed ? :private_scope : :public_scope
      end
      
      kcContents = page.all(:xpath, "//a[contains(@class,'knowledgevideo') and contains(@class,'#{contentType}') and #{publicPrivateOption == :public_scope ? "not(div//div[contains(@class,'lockedContent')])" : "div//div[contains(@class,'lockedContent')]"}]")
      privacy = Event.privacies[publicPrivateOption]
      possibleContents = possibleContents.where(privacy: privacy)
    else
      kcContents = page.all(:xpath, "//a[contains(@class,'knowledgevideo') and contains(@class,'#{contentType}')]")
    end
    
    break if (kcContents.size > 0)
    break if (page.all(".paginator .next a", visible: false).size == 0)
    puts "Next page"
    visit(page.all(".paginator .next a", visible: false)[0][:href])
  end
  assert(kcContents.size > 0, "Must have content")
  
  #check to make sure that the filters were all the correct type of object.
  actualContent = []
  kcContents.each do |kcContent|
    if kcContent[:contentid].present?
      contentInDb = possibleContents.where(id: kcContent[:contentid])[0]
    else
      contentInDb = get_content_for_link(possibleContents, kcContent[:href])
    end
    if publicPrivateOption == :public_scope
      if contentInDb.present?
        #great, no problem
        actualContent << kcContent
      else
        contentInDb = get_content_for_link(@hall.contents, kcContent[:href])
        assert(contentInDb.private_scope?)
        assert(contentInDb.featured == true)
      end
    elsif optionType == "featured"
      assert(contentInDb.present?)
      actualContent << kcContent if (contentInDb.featured ^ !isAllowed) and contentInDb.private_scope?
    elsif publicPrivateOption.nil?
      assert(contentInDb.present?)
    end
    labelInDb = Content::CONTENT_TYPE_LABEL[contentInDb.content_type_code]
    assert(labelInDb == Content::CONTENT_TYPE_LABEL[contentType], "Content type in database: #{labelInDb}, Actual content type: #{Content::CONTENT_TYPE_LABEL[contentType]}")
  end
  
  kcContents = actualContent if actualContent.present?
  
  contentInDb = get_content_for_link(possibleContents, kcContents.first[:href])
  kcContents.first.click
  @content = contentInDb
end
