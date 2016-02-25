require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "csv"
require 'yaml'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups(:assets => %w(development test staging))) if defined?(Bundler)

APP_CONFIG = YAML.load(File.read(File.expand_path('../app_config.yml', __FILE__)))
  
module VirtualExhibition
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.virtual_conferences = ActiveSupport::OrderedOptions.new 
    
    config.virtual_conferences.default_site_name = "Virtual Exhibition"
    config.virtual_conferences.company_url = "commstrat.com.au"
    config.virtual_conferences.events_team_name = "Virtual Events Team"
    config.virtual_conferences.admin_email = "julian.west@commstrat.com.au"
    config.virtual_conferences.event_producer_admin_email = "vconf@commstrat.com.au"
    
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Australia/Melbourne'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # don't generate RSpec tests for views and helpers
    config.generators do |g|
        g.test_framework :rspec, fixture: true
        g.fixture_replacement :factory_girl, dir: 'spec/factories'
        g.view_specs false
        g.helper_specs false
        g.stylesheets = false
        g.javascripts = false
        g.helper = false
    end

    config.assets.enabled = true
    config.assets.digest = true
    config.autoload_paths << Rails.root.join("models_nondb")
    config.autoload_paths << Rails.root.join("jobs")
    config.autoload_paths << Rails.root.join("app","controllers","application_concerns")
    config.autoload_paths << Rails.root.join("app","controllers","hall_sub_controller")
    
    config.active_record.raise_in_transactional_callbacks = true
  end
end
