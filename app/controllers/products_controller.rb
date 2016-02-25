class ProductsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource :only => [:create]

  respond_to :html, :json
  responders :flash
  
  def index
    @products = Product.all.select {|product| can? :index, product}
  end

  def show
  end

  def new
    @product = Product.new
    build_resources
    if current_user.has_role? :booth_rep
      @product.booths = current_user.booths
    end
  end

  def edit
    build_resources
  end
  
  def build_resources
    build_resource :uploaded_file
  end

  def create
    @product = Product.new(product_params)
    @product.save
    
    respond_with @product
  end

  def update
    @product.update(product_params)

    respond_with @product
  end

  def destroy
    @product.destroy
    respond_with @product
  end
  
  def available_booths
    booths = (@product.booths | super).uniq
  end
  
  private
    def product_params
      params.require(:product).permit(:name, :description, :product_url, :image_id, :request_info, 
        :email_notification, :emails, :user_id, :booth_ids => [], uploaded_file_attributes: [:assets, :id] )
    end
end
