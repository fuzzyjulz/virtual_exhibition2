class DummyAnalyticsImpl

  
  def initialize
  end
  
  def write_pageview(request, session, title = nil)
    page = "#{request.fullpath}"
    Rails.logger.info "### DUMMY Pageview Sent(page: #{page}, title: #{title})"
  end
  
  def write_events(request, session)
    GaEvent.get_events(session).each do |event|
      options_str = ""
      if event.options.present?
        event.options.each_pair do |key, value|
          options_str += "#{key} = #{value}"
        end
      end
      Rails.logger.info "### DUMMY Event Sent (#{event})"
    end
  end
end
