When(/^I open the template list$/i) do
  visit(templates_path())
end

When(/^I edit an template$/i) do
  visit(edit_template_path(Template.first.id))
end

When(/^I create a template "(.*)"$/i) do |templateName|
  parameters = {name: templateName}
  parameters[:template_type] = :booth
  parameters[:template_sub_type] = :boothHall
  @template = create_template(parameters)
end

When(/^I update the title of the template to "(.*?)"$/i) do |newTemplateName|
  assert(@template.present?)
  
  open_template(@template)
  click_on "Edit"
  
  fill_in "template_name", with: newTemplateName
  click_button "Update Template"
  report_errors {@template}
  @template.name = newTemplateName
end

When(/^I view the template$/i) do ||
  assert(@template.present?)
  
  open_template(@template)
end

When(/^I delete the template "(.*?)"$/i) do |templateName|
  visit(events_dashboard_path)
  click_on "List templates"
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{templateName}']") {click_on "Destroy"}
end

Then(/^I see the template details$/i) do
  assert(page.has_content?("Template information"))
  
  assert(page.has_content?(@template.name))
  assert(page.has_content?(Template::TEMPLATE_TYPE[@template.template_type]))
  assert(page.has_content?(Template::TEMPLATE_SUB_TYPE[@template.template_sub_type]))
end

Then(/^I expect to( not)? have a template "(.*?)"$/i) do |notHave, templateName|
  visit(templates_path())
  assert(page.has_content?("Listing templates"))
  assert(page.has_content?(templateName)) if notHave.nil?
  assert(! page.has_content?(templateName)) if notHave.present?
  puts Template.pluck(:name)
end


module EventHelpers
  def create_template(options)
    visit(events_dashboard_path)
    
    click_on "Create template"
    
    fill_in "template_name", with: options[:name]
    select Template::TEMPLATE_TYPE[options[:template_type]], from: "template_template_type" if options[:template_type]
    select Template::TEMPLATE_SUB_TYPE[options[:template_sub_type]].name, from: "template_template_sub_type" if options[:template_sub_type]

    click_button "Create Template"
    report_errors {Template.find_by(name: options[:name])}
  end
  
  def open_template(template)
    visit(events_dashboard_path)
    click_on "List templates"
    within(:xpath, "//div[@id='content']//table//tr[td//text()='#{template.name}']") {click_on "Show"}
  end
end

World(EventHelpers)
