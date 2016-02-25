When(/^I open the booth list$/i) do
  visit(event_booths_path(Event.first.id))
end

When(/^I edit a booth$/i) do
  @booth = Booth.first if @booth.nil?
  visit(edit_booth_path(@booth.id))
end

When(/^I own the booth$/i) do
  @booth = Booth.first if @booth.nil?
  @booth.user = @current_user
  @booth.save!
end

When(/^I create a booth "(.*)"$/i) do |boothName|
  parameters = {name: boothName, hall: @event.exhibition_halls.first, template: @booth_template, event: @event, user: @admin_user, publish_status: :published}
  @booth = create_booth(@event, parameters)
end
When(/^I create a booth "(.*)" using parameters$/i) do |boothName, table|
  parameters = {name: boothName, hall: @event.exhibition_halls.first, template: @booth_template, event: @event, user: @admin_user, publish_status: :published}
  
  table.cell_matrix.each do |row|
    name = row[0].value.to_sym
    value = row[1].value
    
    case name
    when :template_name
      name = :template
      value = Template.find_by(name: value)
    when :contents
      value = value.split(",").map { |content_name| Content.find_by(name: content_name)}
    end
    
    parameters[name] = value
  end
  
  @booth = create_booth(@event, parameters)
end

When(/^I create a booth "(.*)" using template "(.*?)"$/i) do |boothName, templateName|
  template = Template.find_by(name: templateName)
  parameters = {name: boothName, hall: @event.exhibition_halls.first, template: template, event: @event, user: @admin_user, publish_status: :published}
  @booth = create_booth(@event, parameters)
end

When(/^I update the title of the booth to "(.*?)"$/i) do |newBoothName|
  assert(@booth.present?)
  
  open_booth(@booth)
  
  fill_in "booth_name", with: newBoothName
  click_button "Update Booth"
  report_errors {@booth}
  @booth.name = newBoothName
end

When(/^I view the booth$/i) do ||
  assert(@booth.present?)
  
  open_booth(@booth)
end

When(/^I delete the booth "(.*?)"$/i) do |boothName|
  open_event(@event)
  click_on "List booths"
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{boothName}']") {click_on "Destroy"}
end

Then(/^I see the booth details$/i) do
  assert(page.has_content?("Edit booth"))

  assert(page.find("#booth_name")[:value] == @booth.name)
  assert(page.has_content?(@booth.hall.name))
  assert(page.has_content?(@booth.template.name))
end

Then(/^I expect to( not)? have a booth "(.*?)"$/i) do |notHave, boothName|
  visit(event_booths_path(Event.first.id))
  assert(page.has_content?("List of booths available"))
  assert(page.has_content?(boothName)) if notHave.nil?
  assert(! page.has_content?(boothName)) if notHave.present?
  puts Booth.pluck(:name)
end

module BoothHelpers
  def create_booth(event, options)
    open_event(event)
    prefix = "booth_"
    
    click_on "Create booth"
    
    fill_in "#{prefix}name", with: options[:name]
    select PublishStatus[options[:publish_status]].label, from: "#{prefix}publish_status" if options[:publish_status]
    select options[:hall].name, from: "#{prefix}hall_id" if options[:hall]
    select options[:template].name, from: "#{prefix}template_id" if options[:template]
    select options[:event].name, from: "#{prefix}event_id" if options[:event]
    select options[:user].name, from: "#{prefix}user_id" if options[:user]
    
    if options[:contents]
      options[:contents].each do |content|
        select content.name, from: "#{prefix}content_ids"
      end
    end

    select PromotionType[options[:promotion_type]].label, from: "#{prefix}promotion_type" if options[:promotion_type]
    fill_in "#{prefix}promotion_url", with: options[:promotion_url] if options[:promotion_url]
    attach_file("#{prefix}promotion_image_attributes_assets", "features/testfiles/#{options[:promotion_image]}") if options[:promotion_image]
      
    click_button "Create Booth"
    report_errors {Booth.find_by(name: options[:name])}
  end

  def open_booth(booth)
    visit(events_dashboard_path)
    open_event(booth.hall.event)
    within(:xpath, "//div[@id='content']") {click_on booth.name}
    click_on "Edit"
  end
end

World(BoothHelpers)
