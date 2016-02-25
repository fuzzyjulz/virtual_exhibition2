VirtualExhibition::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  ###################
  # Internal Settings
  config.virtual_conferences.admin_email = "rebecca.hine@commstrat.com.au"
  
  ###################
  # External Settings 

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  config.assets.precompile += %w( '.woff' '.eot' '.svg' '.ttf' '*.css' admin.css visitor.css shared.css)
  config.assets.precompile += %w( admin-async.js admin-required.js visitor-async.js visitor-required.js shared-async.js shared-required.js shared-required-loggedin.js)

  #config.ember.variant = :development

  config.action_mailer.default_url_options = { :host => 'http://vc-test.herokuapp.com' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.mandrillapp.com", 
    :port                 => 587,
    :domain               => 'vc-test.herokuapp.com',
    :user_name            => ENV["MANDRILL_USERNAME"],
    :password             => ENV["MANDRILL_API_KEY"],
    }

  config.action_mailer.raise_delivery_errors = true

  #config.handlebars.precompile = false
  
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  }

  config.assets.enabled = true
  config.assets.digest = true
  config.action_controller.asset_host = "//#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com"
  config.assets.initialize_on_precompile = true

  config.disqus = ActiveSupport::OrderedOptions.new
  config.disqus.shortname = "virtual-conferences-test"
  config.disqus.category_id = {
      content: "3339308"
    }
end
