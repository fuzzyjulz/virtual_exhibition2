When(/^I open the home page$/i) do
  visit_home_page()
end

When(/^I open the user list$/i) do ||
  visit(users_path)
end

When(/^I open the user list JSON$/i) do ||
  visit(users_path(format: :json))
end

When(/^I edit a user$/i) do ||
  user = User.last
  assert(user != @current_user)
  edit_user(user)
end

When(/^I edit the user( "(.*?), (.*?)")?$/i) do |user_sect, user_surname, user_first_name|
  @user = User.find_by(first_name: user_first_name, last_name: user_surname) if user_sect.present?
  edit_user(@user)
end

When(/^I view a user$/i) do ||
  user = User.last
  assert(user != @current_user)
  open_user(user)
  assert("User details")
end

When(/^I view the user details$/i) do ||
  click_on("Update my profile")
end

When(/^I create a[n]? ?(booth_rep|visitor|admin|producer)? user "(.*?), (.*?)"( with email "(.*?)")?$/i) do |user_type, lastName, firstName, emailSection, emailAddress|
  parameters = {last_name: lastName, first_name: firstName}
  parameters[:email] = 'test@commstrat.com'
  parameters[:state] = 'Vic'
  parameters[:industry] = 'IT'
  parameters[:interested_topic] = 'None'
  parameters[:password] = 'Testing123'
  parameters[:roles] = [user_type] if user_type.present?
  parameters[:email] = emailAddress if emailAddress.present?
  if user_type == "booth_rep"
    parameters[:booths] = [Booth.all.first]
    parameters[:events] = [Event.all.first]
  end
  if user_type == "producer"
    parameters[:events] = [Event.all.first]
  end
  @user = create_user(parameters)
  assert(@user.confirmed?) if defined? @user.confirmed?
end

When(/^I add the user to the "(.*?)" event$/i) do |eventName|
  edit_user(@user)
  
  select eventName, from: "user_event_ids"
  
  click_on "Update User"
  report_errors {@user}
end

When(/^I update the user\'s first name to "(.*?)"$/i) do |firstName|
  edit_user(@user)
  
  fill_in "user_first_name", with: firstName
  
  click_on "Update User"
  report_errors {@user}
  @user.first_name = firstName
end

When(/^I update my first name to "(.*?)"$/i) do |firstName|
  edit_my_details
  
  fill_in "user_first_name", with: firstName
  fill_in "user_current_password", with: "Testing123"
  
  click_on "Update"
  report_errors {@user}
  @user.first_name = firstName
end

When(/^I view the user$/i) do ||
  open_user(@user)
end

When(/^I see the user\'s details$/i) do ||
  assert(page.has_content?(@user.first_name))
  assert(page.has_content?(@user.last_name))
  assert(page.has_content?(@user.email))
  assert(page.has_content?(@user.state))
  assert(page.has_content?(@user.industry))
  assert(page.has_content?(@user.interested_topic))
end

When(/^I delete the user "(.*?), (.*?)"$/i) do |lastName, firstName|
  user = User.find_by(last_name: lastName, first_name: firstName)
  assert (user.present?)
  
  Capybara.current_session.driver.delete user_path(user.id)
end

Then(/^I expect to( not)? see fields: (.*?)$/i) do |notAllowed, fields|
  isAllowed = !notAllowed.present?
  fields.split(",").each do |field|
    field = field.strip
    assert(isAllowed ^ !page.has_content?("#{field}:"), "Field #{field} #{isAllowed ? "not" : ""} found") 
  end
end

Then(/^I expect to( not)? have a user "(.*?), (.*?)"$/i) do |notAllowed, lastName, firstName|
  isAllowed = !notAllowed.present?
  list_users
  visit(users_path(:format => :json))
  if isAllowed
    assert(page.has_content?(lastName))
    assert(page.has_content?(firstName))
    user = User.find_by(last_name: lastName, first_name: firstName)
    assert (user.present?)
    assert(page.has_content?(user.email))
  else
    user = User.find_by(last_name: lastName, first_name: firstName)
    assert(user.nil?)
  end
end

Then(/^I expect the user to( not)? be a[n]? (visitor|booth_rep|admin|producer)$/i) do |notAllowed, user_type|
  assert(notAllowed.present? ^ @user.roles.pluck(:name).include?(user_type))
end

Then(/^I expect the user's possible roles to be:$/i) do |list|
  roles = []
  
  each_list_item(list) do |item|
    roles << item
  end
  Role.all.each do |role|
    assert(roles.include?(role.name) ^ (page.all("#user_role_ids option[text()='#{role.name}']").size == 0), 
        (roles.include?(role.name) ? "Role #{role.name} wasn't found on the page" : "Role #{role.name} was on the page but shouldn't be"))
  end
end

module UserHelpers
  def create_user(options)
    visit(events_dashboard_path())
    
    click_on "Create a user"
    
    prefix = "user_"
    fill_in "#{prefix}first_name", with: options[:first_name]
    fill_in "#{prefix}last_name", with: options[:last_name]
    fill_in "#{prefix}password", with: options[:password]
    fill_in "#{prefix}password_confirmation", with: options[:password_confirmation].nil? ? options[:password] : options[:password_confirmation]
    fill_in "#{prefix}email", with: options[:email]
    select Content::CONTENT_TYPE_LABEL[options[:state]], from: "#{prefix}state" if options[:state]
    if options[:roles].present?
      options[:roles].each do |role|
        select role.to_s, from: "#{prefix}role_ids"
      end
    end
    if options[:booths].present?
      options[:booths].each do |booth|
        select booth.name, from: "#{prefix}booth_ids"
      end
    end
    if options[:events].present?
      options[:events].each do |event|
        select event.name, from: "#{prefix}event_ids"
      end
    end
    fill_in "#{prefix}industry", with: options[:industry]
    fill_in "#{prefix}interested_topic", with: options[:interested_topic]

    click_button "Create User"
    report_errors {User.find_by(email: options[:email])}
  end
  
  def list_users()
    visit(events_dashboard_path)
    click_on "List users"
  end
  
  def open_user(user)
    visit(user_path(user.id))
  end
  
  def edit_user(user)
    open_user(user)
    click_on "Edit"
  end
  
  def edit_my_details()
    visit_home_page
    click_on "Update my profile"
  end
end

World(UserHelpers)
