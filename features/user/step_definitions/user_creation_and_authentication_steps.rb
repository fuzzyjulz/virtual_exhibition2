require 'pry'
Before('@visitor_logged_in') do
  user = db_create_user("visitor")
  user.events << @event if @event
  user.save!
  login_as user
end
Before('@admin_logged_in') do
  user = db_create_user("admin")
  login_as user
end
Before('@producer_logged_in') do
  user = db_create_user("producer")
  login_as user
end
Before('@booth_rep_logged_in') do
  user = db_create_user("booth_rep")
  user.events << @event if @event
  user.save!
  login_as user
end

Given(/^I am logged in as a[n]? (visitor|admin|booth rep|producer)( with a booth)?$/i) do |userType, withABooth|
  userType = "booth_rep" if userType == "booth rep"
  email = "#{userType}.testuser@commstrat.com.au"
  if (user = User.find_by(email: email)).nil?
    user = db_create_user(userType, email: email)
    assert(user.present?, "User must be saved.")
    assert(user.roles.pluck(:name).include?(userType), "User didn't get assigned to the correct type")
    if (userType == "booth_rep" and withABooth.present?)
      Booth.all.each do |booth|
        user.booths << booth
      end
      user.save!
    end
  else
    user.password = "testing"
  end
  login_as user
end

When(/^I log in with email "(.*?)" and password "(.*?)"$/i) do |email, password|
  login_as(email: email, password: password)
end

When(/^I log in as the super admin$/i) do ||
  login_as(email: "test_admin@commstrat.com", password: "EventAdmin")
end

When(/^I log out$/i) do ||
  click_on("Sign out")
  @current_user = nil
end

Then(/^I expect to( not)? see the login popup$/i) do |notAllowed|
  signInButton = page.all(:xpath, "//input[contains(@class,'signInButton')]")
  assert(!notAllowed.nil? ^ (signInButton.size > 0), 
    (notAllowed.nil? ? "Expected to be at the login popup but wasn't" : "Expected to not be at the login popup but was"))
end
Then(/^I expect to( not)? be logged in$/i) do |notAllowed|
  assert(notAllowed.present? ^ user_logged_in?, 
    (notAllowed.nil? ? "Expected to be logged in but wasn't" : "Expected to not be logged in but was"))
end

Then(/^I expect to( not)? be on the sign in page$/i) do |notAllowed|
  assert(notAllowed.present? ^ on_signed_in_page?, 
    (notAllowed.nil? ? "Expected to be logged in but wasn't" : "Expected to not be logged in but was"))
end

Then(/^list users$/i) do ||
  User.all.each {|user| puts "#{user.name()}#{"("+user.roles.pluck("name").join(",")+")" if user.roles}"}
end

Then(/^I expect to( not)? be allowed access$/i) do |notAllowed|
  assert(notAllowed.nil? ^ (page.has_content?("Featured in the Knowledge Centre Tags List") || page.html.include?("You are not authorized to access this page.")), 
    (notAllowed.nil? ? "Expected to be allowed but wasn't allowed access" : "Expected to not be allowed but was allowed access"))
  assert(notAllowed.nil? ^ (current_url_path == "/" || current_url_path =~ /^\/hall\//), "Url was: #{current_url_path}" )
end

module UserCreationHelpers
  DEFAULT_USER = {email:     "testing@commstrat.com.au", 
                  first_name: "Testing",
                  last_name:   "User",
                  password:  "testing",
                  terms: true}
  
  def db_create_user(userType, userDetails = Hash.new)
    DEFAULT_USER.each_pair {|key, value| userDetails[key] ||= value}
    
    User.new(userDetails).tap do |user|
      user.confirm! if defined? user.confirm!
      user.roles.clear << get_role(userType)
      user.save!
    end
  end
  
  def login_as(user)
    email = user.is_a?(Hash) ? user[:email] : user.email
    password = user.is_a?(Hash) ? user[:password] : user.password
    
    visit(new_user_session_path())
    #we have events, and this is a prvate event
    if page.has_button? "Sign in"
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      click_button "Sign in"
    elsif page.has_link?("Not Logged In")
      click_link("Not Logged In")
      within(".loginPanel") do
        fill_in "user_email", with: email
        fill_in "user_password", with: password
        click_button "Sign in"
      end
    else
      assert(false, "Can't find the login button")
    end

    @current_user = User.find_by(email: email)
  end
  
  def on_signed_in_page?
    (page.has_button?("Sign in") or page.has_button?("REGISTER NOW") ) and current_url_path == "/users/sign_in"
  end
  
  def user_logged_in?
    
    if page.all(".userDetailsSection").size == 0
      #for the admin side
      page.all('a[@title="Logout"] > i.fa-power-off').size > 0
    else
      find(".userDetailsSection").text != "Not Logged In"
    end
  end
  
  def get_role(userType)
    role = Role.where(name: userType).first
    if (role.nil?)
      role = Role.new(name: userType)
      role.save!
    end
    role
  end
  
  def current_url_path()
    uri = URI.parse(current_url)
    "#{uri.path}#{"?" if uri.query}#{uri.query}"
  end
end

World(UserCreationHelpers)
