class UserMailer < ActionMailer::Base
  include BusinessLogicHelper
  include PaperclipHelper
  include ActionView::Helpers::AssetTagHelper
  
  helper_method :absolute_paperclip_image_tag
  
  default from: Rails.configuration.virtual_conferences.admin_email
  @unsubscribeable = true;
  
  def send_message_booth(event, user, message, booth)
    _send_booth_email(event, user, message, booth)
  end

  def send_business_card(event, user, message, booth)
    _send_booth_email(event, user, message, booth)
  end
  
  def send_user_redeem_promotion_email(event, current_user, promotion_codes)
    setup_mail_vars(event, current_user)
    @promotion_codes = promotion_codes

    mail_to(:user, "Thanks for visiting - here are your deal codes!")
  end
  
  def send_sponsor_code_redeemed_email(event, current_user, promotion_code)
    setup_mail_vars(event, current_user)
    @promotion_code = promotion_code
    @booth = promotion_code.promotion.booth
    
    mail_to(:booth_owner, "Promotion code #{promotion_code.code} redemption")
  end
  
  private
    def setup_mail_vars(event, user, options = {})
      @user = user
      @message = options[:message] if options[:message]
      @unsubscribeable = false;
      @event = event
      @booth = options[:booth] if options[:booth]
      @event_producer_admin_email = Rails.configuration.virtual_conferences.event_producer_admin_email
    end
  
    def event_from_address(event)
      if event.nil? || !event.event_url.present? || event.event_url == "http://localhost:3000"
        Rails.configuration.virtual_conferences.company_url
      else
        Addressable::URI.parse(event.event_url).host
      end
    end
  
    def _send_booth_email(event, user, message, booth)
      setup_mail_vars(event, user, message: message, booth: booth)
      
      mail_to(:booth_owner, "Important "+@event.name+": new customer message")
    end
    
    def target_email_address(target)
      case target
      when :booth_owner
        to = get_booth_email(@booth)
      when :user
        to = @user.email
      end
      to
    end
    
    def get_booth_email(booth)
      if booth.user.present? && booth.user.email.present?
        booth.user.email
      else
        Rails.configuration.virtual_conferences.admin_email
      end
    end

    def mail_to(to_address, subject)
      
      mail( to: target_email_address(to_address),
        bcc: Rails.configuration.virtual_conferences.admin_email,
        from: '"'+Rails.configuration.virtual_conferences.events_team_name+'('+@event.name.gsub(/"/,"")+')" <noreply@'+event_from_address(@event)+'>',
        subject: subject
       )
    end
end
