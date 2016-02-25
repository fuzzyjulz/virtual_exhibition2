When(/^I visit the home page$/i) do ||
  visit_home_page
end

#This should only be used when testing for specific URLs
When(/^I visit "(.*?)"$/i) do |page|
  page.scan(/\#{(.*?)}/).each do |pattern|
    page = page.gsub "\#{#{pattern[0]}}", "#{eval(pattern[0])}"
  end
  puts "Opening #{page}"
  visit(page)
end

When(/^I clear my browser cookies$/i) do ||
  browser = Capybara.current_session.driver.browser
  browser.clear_cookies
  # Selenium::WebDriver
  #browser.manage.delete_all_cookies
end

When(/^I click on the "(.*?)" menu item$/i) do |menuItem|
  click_on_menu menuItem
end

When(/^I click on the visitor "(.*?)" menu item$/i) do |menuItem|
  click_on_visitor_menu menuItem
end

Then(/^I expect to( not)? see "(.*?)"$/i) do |notAllowed, text|
  assert(notAllowed.present? ^ page.has_content?(text))
end

Then(/^I expect to( not)? see the "(.*?)" menu item[s]?$/i) do |notAllowed, menuItems|
  menuItems.split(",") do |menuItem|
    menuItem = menuItem.strip
    within("nav.navbar"){assert(notAllowed ^ page.has_content?(menuItem))}
  end
end

Then(/^I expect to see the system message "(.*?)"$/i) do |message|
  assert(html.include?(message))
end 

Then(/^I expect the "(.*?)" menu item[s]? to( not)? be selected$/i) do |menuItems, notAllowed|
  menuItems.split(",") do |menuItem|
    menuItem = menuItem.strip
    within("nav.navbar .active"){assert(notAllowed ^ page.has_content?(menuItem))}
  end
end

Then(/^I expect to( not)? be on the Admin Dashboard$/i) do |notAllowed|
  assert(notAllowed ^ page.has_content?("Select from list of available events"))
end

Then(/^I expect to see the text:$/i) do |text|
  each_list_item(text) do |textItem|
    assert(page.has_content?(textItem), "Couldn't find text '#{textItem}'")
  end
end

Then(/^I expect to see get the content "(.*?)"$/i) do |content|
  assert(page.html == content)
end

Then(/^I expect to( not)? be at the url "(.*?)"$/i) do |notAllowed, expected_url|
  assert(notAllowed.present? ^ (expected_url == current_url))
end

Then(/^pry$/i) do ||
  binding.pry
end
module GeneralHelpers
  
  #### FIX FOR AN ISSUE WITH MINITEST AND RAILS 4
  def self.extended(base)
    base.extend(MiniTest::Assertions)
    base.assertions = 0
  end
 
  attr_accessor :assertions
  #### /FIX FOR AN ISSUE WITH MINITEST AND RAILS 4
  
  def admin?
    @current_user && @current_user.has_role?(:admin)
  end

  def admin_or_producer?
    @current_user && (@current_user.has_role?(:admin) || @current_user.has_role?(:producer))
  end

  def booth_rep_or_producer?
    @current_user && (@current_user.has_role?(:producer) || @current_user.has_role?(:booth_rep))
  end
  
  def booth_rep_or_admin?
    @current_user && (@current_user.has_role?(:admin) || @current_user.has_role?(:producer) || @current_user.has_role?(:booth_rep))
  end
  
  def testing_event_url
    "http://example.com"
  end
  
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def visit_home_page()
    visit("/")
  end
  
  def click_on_menu(menuTitle)
    within("nav.navbar"){click_on menuTitle}
  end

  def click_on_visitor_menu(menuTitle)
    within(".visitorMenu"){click_on menuTitle}
  end
  
  def include_hidden_fields
    Capybara.ignore_hidden_elements = false
    yield
    Capybara.ignore_hidden_elements = true
  end
  
  def report_errors
    if defined? yield
      yield.tap do |obj|
        if html.match(/bootstrapGrowl\('(.*?)'/).nil?
          puts "No messages recorded."
        else
          html.match(/bootstrapGrowl\('(.*?)'/).captures.each do |error|
            puts error
          end
        end
      end
    else
      if html.match(/bootstrapGrowl\('(.*?)'/).nil?
        puts "No messages recorded but no object stored."
      else
        html.match(/bootstrapGrowl\('(.*?)'/).captures.each do |error|
          puts error
        end
      end
    end
  end
  
  def each_list_item(list, &block)
    list.cell_matrix.each do |row|
      block.call row[0].value
    end
  end
end

World(GeneralHelpers)
