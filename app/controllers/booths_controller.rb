class BoothsController < ApplicationController
  UNAUTHENTICATED_PAGES = [:visit, :about, :products, :literature, 
                           :add_promotion_to_cart, :company_website, 
                           :facebook, :twitter, :linkedin, :googleplus]
  
  before_action :authenticate_user!, except: UNAUTHENTICATED_PAGES
  before_action :authenticate_user!, only: UNAUTHENTICATED_PAGES, if: Proc.new { |this| @current_event.present? and @current_event.private_scope? }
  load_and_authorize_resource :except => UNAUTHENTICATED_PAGES
  skip_load_resource :only => [:create]
  before_action :set_templates, only: [:new, :edit]
  before_action :not_live_event, if: Proc.new { |this| @booth.nil? || @booth.hall.nil? ? false : !@booth.hall.event.live?}
  
  respond_to :html, :json
  responders :flash
  
  helper_method :get_ticker_message_arr
  helper_method :get_resources
  helper_method :new_path, :index_path, :background_image

  include ShoppingCartHelper
  include AddableToCart
  
  def background_image
    if request["action"] == "visit" and @booth.present? and @booth.template.uploaded_file.present?
      @booth.template.uploaded_file.url
    else
      nil
    end 
  end
  
  def style
    if @booth and @booth.template
      @booth.template.template_sub_type
    else
      nil
    end
  end
    
  def new_path
    @hall.present? ? new_hall_booth_path(@hall) : new_event_booth_path(@event)
  end
  
  def index_path
    @hall.present? ? hall_booths_path(@hall) : event_booths_path(@event)
  end
  

  def index
    if (@hall.present?)
      @booths = @hall.booths
    else 
      @booths = @event.booths
    end
    @booths = @booths.order(:name).select {|booth| can? :show, booth}
    respond_with(@booths)
  end

  def visit
    @chats = Chat.where(:chattable_type => 'Booth', :chattable_id => @booth.id)
    @visualContent = filter_contents(@booth.contents.includes(:thumbnail_image).order(:order_index, :id), Content::VIDEO_CONTENT_TYPES + [:slideshare, :image])
    set_prev_next_booth
  end
  
  def set_prev_next_booth
    allBoothsInHall = @booth.hall.published_booths
    @prev_booth = allBoothsInHall.where("name < ?", @booth.name).order(:name => :desc).first
    @next_booth = allBoothsInHall.where("name > ?", @booth.name).order(:name => :asc).first
  end

  def new
    @booth = Booth.new
    @booth.event = @event
    @booth.template = @templates.first if @templates.size == 1
    
    build_resources
  end

  def edit
    build_resources
  end

  def create
    @booth = Booth.new(booth_params)
    @booth.save
    respond_with(@booth, location: show_booth_path(@booth))
  end

  def update
    @booth.update(booth_params)
    sync_update @booth if params['booth']['chat'].present? if !@booth.errors.present?
    respond_with(@booth, location: show_booth_path(@booth))
  end

  def destroy
    @hall = @booth.hall
    @booth.destroy
    respond_with(@booth, location: hall_booths_path(@booth.hall))
  end
  
  def add_promotion_to_cart
    promotion = @booth.live_promotion
    if promotion.nil?
      flash[:error] = "No active promotions"
    else
      if (promotion_code = add_to_cart(promotion))
        record_event(GaEvent.new(category: :booth, action: :add_promotion_to_cart, 
          label: "promotion:#{promotion.id}, promotion_code: #{promotion_code.code}").booth(@booth))
      else
        flash[:error] = "Sorry, we have run out of deals for #{@booth.name}"
      end
    end
    redirect_to(booths_visit_path(@booth))
  end

  def company_website
    record_event(GaEvent.new(category: :booth, action: :click_to_company_website).booth(@booth))

    redirect_to @booth.company_website
  end
  
  %w[facebook twitter linkedin googleplus].each do |followus|
    define_method(followus) do
      record_event(GaEvent.new(category: :booth, action: "click_to_#{followus}".to_sym).booth(@booth))
      
      redirect_to @booth.followus_item(followus.to_sym).url
    end
  end
  
  %w(about leave_business_card products literature contact contact_info).each do |method_name|
    define_method(method_name) { render layout: "modal_box" }
  end
  
  def get_resources()
    @resources ||= filter_contents(@booth.contents, [:resource])
    return @resources
  end
  
  def send_message
    send_booth_email(:send_message_booth)

    render "send_message.js"
  end
  
  def send_business_card
    send_booth_email(:send_business_card)
    render "send_business_card.js"
  end
  
  def send_booth_email(message_type)
    user = User.find(params[:user][:id])
    mail = UserMailer.send(message_type, get_event(), user, params[:user][:message], @booth)
    mail.deliver if Role.find_by(name: :test_admin).nil?
    record_event(GaEvent.new(category: :booth, action: message_type).booth(@booth))
  end

  def get_ticker_message_arr()
    
    #get rid of any divs and change them to line breaks (this is how the control represents line breaks)
    tickerMessage = @booth.ticker_message.gsub(/<div.*?>/,"<br>").gsub("</div>","")
    
    tickerMessage = tickerMessage.gsub(/<a/,"<a target='_blank' ") #force link targets to a new tab
    
    tickerMessageArr = tickerMessage.split(/<br.*?>/)
    
    forceLineBreaksOnHtml(tickerMessageArr, 75)
    
  end
  
private
    def set_templates
      @templates = Template.where(template_type: :booth)
    end

    def build_resources
      build_resource :company_logo, :thumbnail_image, :about_us_header_image, :about_us_footer_image
    end

    def booth_params
      params.require(:booth).permit(:name, :tagline, :top_message, :company_website, :contact_info, :email, :about_us, :button1_label, :button1_content, 
        :event_id, :public_chat, :ticker_message, :user_id, :display_mode, :booth_list_message, :related_sponsor_tagline, 
        :template_id, :hall_id, :publish_status,
        :followus_url_twitter, :followus_url_facebook, :followus_url_linkedin, :followus_url_googleplus, 
        :tag_ids => [], :content_ids => [],
        company_logo_attributes: [:assets, :id], 
        thumbnail_image_attributes: [:assets, :id],
        about_us_header_image_attributes: [:assets, :id],
        about_us_footer_image_attributes: [:assets, :id])
    end
end
