module Analytics
  extend ActiveSupport::Concern
  
  included do
    before_action :initialise_analytics
    helper_method :write_pageview
    helper_method :write_events
  end
  
  def analytics
    @analytics ||= (Rails.env.production? ? GoogleAnalyticsImpl.new(request, session, cookies, campaign, current_user) : DummyAnalyticsImpl.new)
  end

  def initialise_analytics
   begin
     @campaign = UtmCampaign.campaign(session)
     if !@campaign.present?
       @campaign = UtmCampaign.create_campaign(session, request, params) 
     end 
   rescue Exception => e
     logger.error e.to_s
     logger.error e.backtrace.join("\n")
   end
  end
  
  def write_pageview(title = nil)
    begin
      event = @current_event
      title ||= event.present? ? event.name : Rails.configuration.virtual_conferences.default_site_name
      
      analytics.write_pageview(request, session, title)
    rescue Exception => e
      logger.error e.to_s
      logger.error e.backtrace.join("\n")
    end
  end
  
  def write_events
    begin
      analytics.write_events(request, session)
      GaEvent.clear(session)
    rescue Exception => e
      logger.error e.to_s
      logger.error e.backtrace.join("\n")
    end
  end

  def record_event(event)
    begin
        event.add_event(session)
        write_events
    rescue Exception => e
      logger.error e.to_s
      logger.error e.backtrace.join("\n")
    end
  end
end
