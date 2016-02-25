When(/^I register for the event$/i) do
  visit_home_page
  click_on("REGISTER NOW")
  prefix = "user_"
  userDetails = get_user_details[:direct]
  
  fill_in "#{prefix}email", with: userDetails[:email]
  fill_in "#{prefix}password", with: userDetails[:password]
  fill_in "#{prefix}password_confirmation", with: userDetails[:password]
  fill_in "#{prefix}position", with: userDetails[:position]
  fill_in "#{prefix}company", with: userDetails[:company]
  find("##{prefix}terms").set(true)
  
  select userDetails[:title], from: "#{prefix}title"
  fill_in "#{prefix}first_name", with: userDetails[:first_name]
  fill_in "#{prefix}last_name", with: userDetails[:last_name]
  select userDetails[:state], from: "#{prefix}state"
  fill_in "#{prefix}industry", with: userDetails[:industry]
  
  click_on "Sign up"
  
  @current_user = report_errors {User.find_by(email: "testing@commstrat.com")}
end

When(/^I register for the event with linkedin( returning no details)?$/i) do |noDetails|
  visit_home_page
  OmniAuth.config.test_mode = true
  if (noDetails.present?)
    OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
          provider: 'linkedin',
          uid: '123545',
          info: {}
        })
  else
    userDetails = get_user_details[:linkedin]
    OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
          provider: 'linkedin',
          uid: '123545',
          info: {
            name: "#{userDetails[:first_name]} at #{userDetails[:last_name]}",
            email: userDetails[:email],
            first_name: userDetails[:first_name],
            last_name: userDetails[:last_name],
            description: "#{userDetails[:position]} at #{userDetails[:company]}",
            image: userDetails[:avatar]
          },
          extra: {
            raw_info: {
              industry: userDetails[:industry]
            }
          }
        })
  end
  
  click_on "Linkedin"

  if (!noDetails.present?)
    prefix = "user_"
    find("##{prefix}terms").set(true)
    click_on "Sign up"
  end
end

When(/^I register for the event with facebook( returning no details)?$/i) do |noDetails|
  visit_home_page
  OmniAuth.config.test_mode = true
  if (noDetails.present?)
    OmniAuth.config.mock_auth[:linkedin] = OmniAuth::AuthHash.new({
          provider: 'facebook',
          uid: '123545'
        })
  else
    userDetails = get_user_details[:facebook]
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          provider: 'facebook',
          uid: '123545',
          info: {
            name: "#{userDetails[:first_name]} at #{userDetails[:last_name]}",
            email: userDetails[:email],
            first_name: userDetails[:first_name],
            last_name: userDetails[:last_name],
            image: userDetails[:avatar]
          }
        })
  end
  
  click_on "Facebook"
  
  if (!noDetails.present?)
    prefix = "user_"
    find("##{prefix}terms").set(true)
    click_on "Sign up"
  end
end

When(/^I confirm my email account$/i) do
  assert(@current_user)
  #only do this if it's confirmable
  if defined? @current_user.confirm!
    visit(user_confirmation_path(confirmation_token: get_confirmation_token))
    assert(!page.has_content?("Resend confirmation instructions"))
  end
end

When(/^I login using the direct user credentials$/i) do
  userDetails = get_user_details[:direct]
  visit_home_page
  fill_in "user_email", with: userDetails[:email]
  fill_in "user_password", with: userDetails[:password]
  click_on("Sign in")
  
  @current_user = User.find_by(email: userDetails[:email])
end

When(/^I login using linkedin$/i) do
  visit_home_page
  click_on "Linkedin"
end

When(/^I login using facebook$/i) do
  visit_home_page
  click_on "Facebook"
end

When(/^I open the sign up page for event "(.*?)"$/i) do |eventName|
  event = Event.find_by(name: eventName)
  assert(event.present?)
  visit(user_sign_up_path(event.id))
end

Then(/^I expect to see the user registration page$/i) do
  assert(page.has_content?("Sign up"))
  assert(page.has_content?("I have read and agree to the Terms & Conditions"))
  assert(page.has_content?("What industry sector do you work in?"))
end

Then(/^I expect to see the (linkedin|facebook|direct) user details$/i) do |authModel|
  userDetails = get_user_details[authModel.to_sym]
  prefix = "user_"
  assert(find("##{prefix}email").value == userDetails[:email]) if userDetails[:email].present?
  assert(find("##{prefix}first_name").value == userDetails[:first_name]) if userDetails[:first_name].present?
  assert(find("##{prefix}last_name").value == userDetails[:last_name]) if userDetails[:last_name].present?
  assert(find("##{prefix}position").value == userDetails[:position]) if userDetails[:position].present?
  assert(find("##{prefix}company").value == userDetails[:company]) if userDetails[:company].present?
  assert(find("##{prefix}industry").value == userDetails[:industry]) if userDetails[:industry].present?
  assert(find("##{prefix}title").value == userDetails[:title]) if userDetails[:title].present?
  assert(find("##{prefix}state option[selected]").text == userDetails[:state]) if userDetails[:state].present?
  assert(find("nav.navbar .user-img")[:src] == userDetails[:avatar]) if userDetails[:avatar].present?
end

Then(/^I expect to( not)? be able to register$/i) do |notAllowed|
  assert(notAllowed.present? ^ page.has_link?("REGISTER NOW"))
end

module VisitorSignUpHelpers
  USER_DETAILS = {
    linkedin: {
      first_name: "Linkedin",
      last_name: "User",
      email: "test-linkedin@commstrat.com",
      position: "Dummy testing user",
      company: "CommStrat",
      industry: "Mocking Services",
      avatar: "http://localhost/dummy.jpg"
    },
    facebook: {
      first_name: "Facebook",
      last_name: "User",
      email: "test-facebook@commstrat.com",
      avatar: "http://localhost/dummy.jpg"
    },
    direct: {
      first_name: "Testing",
      last_name: "User",
      email: "testing@commstrat.com",
      position: "Test User",
      company: "Commstrat",
      industry: "Media and Conferences",
      title: "Mr",
      state: "Victoria",
      password: "testuser123"
    }
  }
  def get_user_details
    USER_DETAILS
  end
  
  def get_confirmation_token()
    email = last_email
    email && email.body && email.body.match(/confirmation_token=(.+)">/x)[1]
  end
end

World(VisitorSignUpHelpers)
