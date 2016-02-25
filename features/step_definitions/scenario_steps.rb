Given(/^a( second)? basic( public)? event$/i) do |secondEvent, public_event|
  if secondEvent.present?
    event = Event.first
    event.name = "Second Event"
    event.event_url = nil
    event.event_welcome_heading = "This is the Second Event"
    event.save!
  end

  db_create_event()

  if (public_event)
    @event.privacy = :public_scope
    @event.save!
  end
  
  #this is required as the login tags execute before the background task :-(
  db_add_all_users_to_event(@event)
end

Given(/^I own all booths$/i) do ||
  User.all.each do |user|
    if user.has_role? :booth_rep
      Booth.all.each do |booth|
        booth.user = user
        booth.save!
      end
    end
  end 
end

When(/^I log in as the event admin$/i) do ||
  login_as(email: @admin_user.email, password: "EventAdmin")
end

module ScenarioHelpers
  def db_create_event()
    Role.new(name: "admin").save! if !Role.find_by(name: "admin").present?
    Role.new(name: "producer").save! if !Role.find_by(name: "producer").present?
    Role.new(name: "booth_rep").save! if !Role.find_by(name: "booth_rep").present?
    Role.new(name: "visitor").save! if !Role.find_by(name: "visitor").present?
    Role.new(name: "test_admin").save! if !Role.find_by(name: "test_admin").present?
    
    if !User.find_by(email: "test_admin@commstrat.com").present?
      @admin_user = db_create_user("admin", first_name: "Admin", email: "test_admin@commstrat.com", password: "EventAdmin", status: "Yes")
      @admin_user.roles << Role.find_by(name: "test_admin")
      @admin_user.save!
    end
    
    db_create_auth_models
    
    @event = Event.new(name: "First Event",
              auth_models: [AuthModel.direct, AuthModel.linkedin, AuthModel.facebook], can_register: true,
              start: "2014-01-01", finish: "2099-07-01", event_url: testing_event_url)
    @event.event_welcome_heading = "This is the First Event"
    @event.privacy = :private_scope
    @event.save!
    if !@admin_user.events.include?(@event)
      @admin_user.events << @event
      @admin_user.save!
    end
    
    db_create_templates if !(defined? @main_hall_template)
  
    mainHall = Hall.new(name: "Main Hall", template: @main_hall_template, event: @event, publish_status: PublishStatus.published.id)
    File.open("features/testfiles/conference_hall.jpg") do |hall_template|
      mainHall.build_background_image.assets = hall_template
    end 
    mainHall.save!
    
    @event.landing_hall = mainHall
    @event.save!
  
    exhibitionHall = Hall.new(name: "Exhibition Hall", template: @booth_hall_template, event: @event, parent: mainHall, publish_status: PublishStatus.published.id)
    exhibitionHall.save!
    
    db_create_all_content_booth(exhibitionHall)
    db_create_all_content_booth_v2(exhibitionHall)
    
    db_create_knowledge_lib()
    
    knowledge_library = Hall.new(name: "Knowledge Center Tags List", template: @knowledge_lib_tags_template, event: @event, parent: mainHall, publish_status: PublishStatus.published.id)
    knowledge_library.save!
  end
  
  def db_create_auth_models
    if AuthModel.find_by(code: "direct").nil?
      AuthModel.new(name: "Direct", code: "direct").save!
    end
    if AuthModel.find_by(code: "facebook").nil?
      AuthModel.new(name: "Facebook", code: "facebook").save!
    end
    if AuthModel.find_by(code: "linkedin").nil?
      AuthModel.new(name: "LinkedIn", code: "linkedin").save!
    end
  end
  
  def db_add_all_users_to_event(event)
    #this is required as the login tags execute before the background task :-(
    User.all.each do |user|
      if ! user.has_role? :admin
        user.events << event
        user.save!
      end 
    end
  end
  
  def db_create_all_content_booth(exhibitionHall)
    ticker_message = "<div>Hi, This is a ticker message. I guess that it takes a lot of text to fill this up.</div><div>Or maybe it doesn't</div>"
    
    allContentBooth = Booth.new(name: "All Content", 
                                template: @booth_template, 
                                hall: exhibitionHall, 
                                event: @event, 
                                user: @admin_user,
                                publish_status: PublishStatus.published.id, 
                                ticker_message: ticker_message,
                                about_us: "### About Us Content Goes Here ###",
                                contact_info: "### Contact Info ###",
                                top_message: "### Top Message ###")
    allContentBooth.save!
    
    db_create_all_content_types(allContentBooth.name).each do |content|
      content.booths << allContentBooth
      if content.content_type_code == ContentType[:resource].id
        content.save!(validate: false)
      else
        content.save!
      end
    end
    
    product = Product.new(name: "Awesome Product", description: "What a great product! how could you not want to buy it????", booths: [allContentBooth])
    product.save!
    
    @all_content_booth = allContentBooth
  end

  def db_create_all_content_booth_v2(exhibitionHall)
    allContentBooth = Booth.new(name: "All Content v2", 
                                template: @booth_v2_template, 
                                hall: exhibitionHall, 
                                event: @event, 
                                user: @admin_user, 
                                publish_status: PublishStatus.published.id,
                                about_us: "### About Us Content Goes Here ###",
                                contact_info: "### Contact Info ###",
                                top_message: "### Top Message ###",
                                company_website: "http://marcs.org.au",
                                followus_url_twitter: "http://twitter.com",
                                followus_url_facebook: "http://facebook.com",
                                followus_url_linkedin: "http://linkedin.com",
                                followus_url_googleplus: "http://plus.google.com")
    allContentBooth.save!
    
    db_create_all_content_types(allContentBooth.name).each do |content|
      content.booths << allContentBooth
      if content.content_type_code == ContentType[:resource].id
        content.save!(validate: false)
      else
        content.save!
      end
    end
    
    promotion = Promotion.new(name: "Free Stuff", open_date: "2000-07-01", closed_date: "2099-07-01", booth: allContentBooth, promotion_type: PromotionType.std_cart_deal.id)
    promotion.save!
    
    promotion_code = PromotionCode.new(code: "FS1000", promotion: promotion)
    promotion_code.save!
    
    @all_content_booth_v2 = allContentBooth
  end

  def db_create_knowledge_lib()
    knowledge_library = Hall.new(name: "Knowledge Central", template: @knowledge_lib_template, event: @event, publish_status: PublishStatus.published.id)
    knowledge_library.save!
    
    db_create_all_content_types("Knowledge Center").each do |content|
      if @sponsored_content.nil?
        content.update!(sponsor_booth_id: @all_content_booth.id)
        @sponsored_content = content
      end
      content.halls << knowledge_library
      if content.content_type_code == ContentType[:resource].id
        content.save!(validate: false)
      else
        content.save!
      end
    end
  end
  
  def db_create_all_content_types(namePrefix)
    contents = []
    
    content = Content.new(name: "#{namePrefix}: YouTube Video", content_type: ContentType[:youtube_video].id, owner_user: @admin_user, event: @event)
    content.external_id = "oe92f-wecrI"
    content.privacy = :private_scope
    content.featured = true
    content.save!
    contents << content
    
    tag = Tag.new(name: "#{namePrefix}: Amazeballs Videos", featured: true, event: @event, tag_type: :topic)
    tag.contents << content 
    tag.save!

    content = Content.new(name: "#{namePrefix}: Private Unfeatured YouTube Video", content_type: ContentType[:youtube_video].id, owner_user: @admin_user, event: @event)
    content.external_id = "oe92f-wecrI"
    content.privacy = :private_scope
    content.featured = false
    content.save!
    contents << content

    content = Content.new(name: "#{namePrefix}: Public YouTube Video", content_type: ContentType[:youtube_video].id, owner_user: @admin_user, event: @event)
    content.external_id = "oe92f-wecrI"
    content.privacy = :public_scope
    content.featured = false
    content.save!
    contents << content

    content = Content.new(name: "#{namePrefix}: Private Unfeatured Wistia Video", content_type: ContentType[:wistia_video].id, owner_user: @admin_user, event: @event)
    content.external_id = "fe8t32e27x"
    content.privacy = :private_scope
    content.featured = false
    content.save!
    contents << content

    content = Content.new(name: "#{namePrefix}: Private Unfeatured Vimeo Video", content_type: ContentType[:vimeo_video].id, owner_user: @admin_user, event: @event)
    content.external_id = "76979871"
    content.privacy = :private_scope
    content.featured = false
    content.save!
    contents << content

    content = Content.new(name: "#{namePrefix}: Slideshare Presentation", content_type: ContentType[:slideshare].id, owner_user: @admin_user, event: @event)
    content.external_id = "31194963"
    content.privacy = :private_scope
    content.featured = true
    content.save!
    contents << content

    tag = Tag.new(name: "#{namePrefix}: Secret Slides", featured: false, event: @event, tag_type: :topic)
    tag.contents << content 
    tag.save!

    content = Content.new(name: "#{namePrefix}: Local Resource", content_type: ContentType[:resource].id, owner_user: @admin_user, event: @event)
    File.open("features/testfiles/conference_hall.jpg") do |thumbnail|
      content.build_thumbnail_image.assets = thumbnail
    end 
    content.privacy = :private_scope
    content.save!
    #for some reason this gets set to a zip file??? this bypasses the validation.
    File.open("features/testfiles/golden_brown.docx") do |resource_file|
      content.build_resource_file.assets = resource_file
    end 
    content.save!(validate: false)
    contents << content

    content = Content.new(name: "#{namePrefix}: Remote Resource", content_type: ContentType[:resource].id, owner_user: @admin_user, event: @event)
    content.external_id = "http://commstrat.com.au/testimage"
    File.open("features/testfiles/conference_hall.jpg") do |thumbnail|
      content.build_thumbnail_image.assets = thumbnail
    end 
    content.privacy = :private_scope
    content.save!
    contents << content

    content = Content.new(name: "#{namePrefix}: Image", content_type: ContentType[:image].id, owner_user: @admin_user, event: @event)
    File.open("features/testfiles/conference_hall.jpg") do |thumbnail|
      content.build_thumbnail_image.assets = thumbnail
    end 
    content.privacy = :private_scope
    content.save!
    contents << content
    
    tag = Tag.new(name: "#{namePrefix}: All Content", featured: true, event: @event, tag_type: :topic)
    #contents.each { |content| tag.contents << content }
    tag.save!
    
    tag = Tag.new(name: "#{namePrefix}: Empty Tag", featured: true, event: @event, tag_type: :topic)
    tag.save!

    contents
  end
  
  def db_create_templates
    @main_hall_template = Template.new(name: "Main Hall Template", template_type: :mainHall, template_sub_type: :main_hall)
    @main_hall_template.save!
    
    @booth_hall_template = Template.new(name: "Booth Hall Template", template_type: :exhibitionHall, template_sub_type: :exhibition_hall)
    @booth_hall_template.save!
    
    @knowledge_lib_template = Template.new(name: "Knowledge Library Template", template_type: :knowledgeLibraryHall, template_sub_type: :knowledge_knowledgeLibrary)
    @knowledge_lib_template.save!
    
    @knowledge_lib_tags_template = Template.new(name: "Knowledge Library Tags Template", template_type: :knowledgeLibraryHall, template_sub_type: :knowledge_tagList)
    File.open("features/testfiles/conference_hall.jpg") do |hall_template|
      @knowledge_lib_tags_template.build_uploaded_file.assets = hall_template
    end 
    @knowledge_lib_tags_template.save!

    @booth_template = Template.new(name: "Booth Template", template_type: :booth, template_sub_type: :boothHall)
    File.open("features/testfiles/booth_thumb.png") do |booth_template|
      @booth_template.build_thumbnail_image.assets = booth_template
    end 
    @booth_template.save!

    @booth_v2_template = Template.new(name: "Booth Template v2", template_type: :booth, template_sub_type: :booth_v2)
    File.open("features/testfiles/booth_thumb.png") do |booth_template|
      @booth_v2_template.build_uploaded_file.assets = booth_template
    end 
    @booth_v2_template.save!
  end
end

World(ScenarioHelpers)
