When(/^I open the product list$/i) do
  list_products
end

When(/^I edit a product$/i) do
  @product = Product.first if @product.nil?
  visit(edit_product_path(@product.id))
end

Then(/^I create a product "(.*?)"$/i) do |productName|
  event = Event.first
  parameters = {name: productName, description: "A product description is required here :-)", booths: [@all_content_booth]}

  @product = create_product(event, parameters)
  puts @product.to_json
  assert(@product.present?)
end

Then(/^I expect to( not)? have a product "(.*?)"$/i) do |notAllowed, productName|
  list_products
  assert(notAllowed.present? ^ page.has_content?(productName))
end

Then(/^I view the product$/i) do ||
  assert(@product.present?)
  view_product_by_name(@product.name)
end

Then(/^I update the title of the product to "(.*?)"$/i) do |productName|
  list_products
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{@product.name}']") {click_on "Edit"}
  
  fill_in "product_name", with: productName
  click_on "Update Product"
  @product.name = productName
end

Then(/^I delete the product "(.*?)"$/i) do |productName|
  list_products
  within(:xpath, "//div[@id='content']//table//tr[td//text()='#{productName}']") {click_on "Delete"}
end

Then(/^I expect to( not)? see the product details$/i) do |notAllowed|
  assert(@product.present?)
  assert(notAllowed.present? ^ page.has_content?("Product details"))
  assert(notAllowed.present? ^ page.has_content?(@product.name))
  assert(notAllowed.present? ^ page.has_content?(@product.description))
end

module ContentHelpers
  def create_product(event, options)
    open_event(event)
    
    click_on "Create product"
    prefix = "product_"
    fill_in "#{prefix}name", with: options[:name]
    fill_in "#{prefix}description", with: options[:description]
    options[:booths].each do |booth|
      select booth.name, from: "product_booth_ids"
    end
    
    click_button "Create Product"
    report_errors { Product.find_by(name: options[:name]) }
  end
  
  def list_products()
    if @current_user.has_role?(:visitor) or @current_user.has_role?(:booth_rep)
      visit(products_path(Event.first))
    else
      click_on("List products")
    end
  end
  
  def view_product_by_name(productName)
    list_products
    page.within(:xpath, "//div[@id='content']//table//tr[td//text()='#{productName}']") {click_on "View"}
  end
end

World(ContentHelpers)
