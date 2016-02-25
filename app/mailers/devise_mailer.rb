class DeviseMailer < Devise::Mailer   
  #helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def confirmation_instructions(record, token, opts={})
  	if record.events.present?
  		name = record.events.last.name
  		@event = name
  	else
  		name = "#{record.first_name},"
  	end
    opts[:from] = "noreply@#{URI(record.events.last.event_url).host}" if record.events.last.event_url? if record.events.present?
    opts[:subject] ="#{name} Registration - Confirmation Required"
    super
  end
end