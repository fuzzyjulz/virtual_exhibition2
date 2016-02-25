source 'http://rubygems.org'
ruby '2.0.0'
gem 'rails'
gem 'pg'                                              #Pg is the Ruby interface to the PostgreSQL RDBMS.
gem 'devise'                                          #Flexible authentication solution for Rails with Warden.
gem 'devise_invitable'                                #An invitation strategy for devise
gem 'devise_lastseenable'                             #This ensures that devise will update a last_seen flag on the model whenever you check if a user is authed.
gem 'cancan'                                          #Authorization Gem for Ruby on Rails.
gem 'rolify', :git => "git://github.com/EppO/rolify.git" #Role management library with resource scoping
gem 'active_model_serializers'                        #ActiveModel::Serializer implementation and Rails hooks
gem 'jquery-rails'                                    #A gem to automate using jQuery with Rails
gem 'figaro'                                          #Provides ENV support for private information
gem 'haml-rails'                                      #Haml-rails provides Haml generators for Rails 4. It also enables Haml as the templating engine for you
gem 'simple_form'                                     #Forms made easy for Rails! It's tied to a simple DSL, with no opinion on markup.

#4.0.2 required to support Rails and twitter bootstrap
gem 'sass-rails', "~> 4.0.2"                          #This gem provides official integration for Ruby on Rails projects with the Sass stylesheet language.
gem 'bootstrap-sass'                                  #Official Sass port of Bootstrap by Twitter
gem 'coffee-rails'                                    #CoffeeScript adapter for the Rails asset pipeline. Also adds support to use CoffeeScript to respond to JavaScript requests (use .js.coffee views).
gem 'uglifier', '>= 1.3.0'                            #UglifyJS JavaScript compressor.
gem 'font-awesome-rails'                              #The font-awesome font bundled as an asset for the rails asset pipeline
gem 'video_info'                                      #Provides video metadata for youtube and vimeo
gem "paperclip"                                       #Allows files to be attached to models, and stored in AWS
gem 'aws-sdk', "<2"                                   #The official Amazon Web Services SDK for Ruby. - not sure if this is used
gem 'ancestry'                                        #Ancestry is a gem/plugin that allows the records of a Ruby on Rails ActiveRecord model to be organised as a tree structure (or hierarchy)
gem 'pusher'                                          #For pushing realtime events between clients
gem 'sync'                                            #Real-time partials with Rails. Sync lets you render partials for models that, with minimal code, update in realtime in the browser when changes occur on the server.
gem 'asset_sync'                                      #for syncing content to Amazon S3
gem "browser"                                         #Do some browser detection with Ruby. Includes ActionController integration.
gem 'kaminari'                                        #Pagination of data
gem 'redis'                                           #Redis is an in-memory database that persists on disk. 
gem 'resque', :require => "resque/server"             #For queueing jobs and processes
gem 'resque-scheduler'                                #Resque-scheduler is an extension to Resque that adds support for queueing items in the future.
gem 'resque-status'                                   #An extension to the resque queue system that provides simple trackable jobs.
gem 'thin'                                            #A very fast & simple Ruby web server

gem 'omniauth'                                        #OmniAuth is a library that standardizes multi-provider authentication for web applications
gem 'omniauth-facebook'                               #Omniauth facebook integration
gem 'omniauth-twitter'                                #Omniauth Twitter integration
gem 'omniauth-linkedin-oauth2'                        #Omniauth Linked In integration - forked from omniauth-linkedin-oauth2
gem 'omniauth-google-oauth2'                          #Omniauth Google integration
gem 'responders'                                      #Allows for simplifying alert messages in controllers
gem 'dynamic_sitemaps'                                #Generates a sitemap for the event.

                                                      #Does server side Google analytics recording.
#gem 'gabba-gmp', path: '/BitNami/rubystack-2.0.0-4/projects/gabba-gmp' # does server side Google analytics recording.
#gem 'gabba-gmp', git: 'git://github.com/fuzzyjulz/gabba-gmp.git' # does server side Google analytics recording.
gem 'gabba-gmp'                                       #Does server side Google analytics recording.
gem 'acts_as_shopping_cart'                           #Adds in a basic shopping cart
gem 'ar_outer_joins'                                  #Adds in outer joins to ActiveRecord

group :development, :test do

  #Testing frameworks
  gem 'database_cleaner'                              #cleans out the database between tests
  gem 'rspec'                                         #For unit tests
  gem 'rspec-rails', '~> 2.0'                         #For Unit Tests
  gem 'cucumber-rails', require: false                #For Behavior Driven Development
end

group :development do
  gem 'pry'                                           #pry is a command line debugger It allows debugging in the console and looking up help for commands
  gem 'pry-debugger'                                  #Adds step, next, finish, and continue commands and breakpoints to Pry using debugger.
  gem 'pry-rails'                                     #Use pry-rails instead of copying the initializer to every rails project. This is a small gem which causes rails console to open pry. It therefore depends on pry.
  
  gem 'better_errors'                                 #Replaces the standard Rails error page with a much better and more useful error page.
  gem 'binding_of_caller'                             #Allows the errors screen to run commands. 
  
  gem 'hub', :require=>nil                            #extends standard git command with additional GITHUB commands
  gem 'quiet_assets'                                  #Quiet Assets turns off the Rails asset pipeline log. like: Started GET "/assets/application.js?body=1" for 127.0.0.1 at 2012-02-13 13:24:04 +0400 AND Served asset /application.js - 304 Not Modified (8ms)
  gem 'tzinfo-data', platforms: [:mingw, :mswin] #Timezone gem requires for rails 4 under windows...
end
group :test do
  gem 'codeclimate-test-reporter'                     #code climate test coverage
end
group :production do
  gem 'rails_12factor'                                #serve assets in production and setting your logger to standard out, both of which are required to run a Rails 4 application on a twelve-factor provider. The gem also makes the appropriate changes for Rails 3 apps.
  gem 'newrelic_rpm'                                  #provides you with deep information about the performance of your web application as it runs in production.
end

#Unused Gems:
  #All:
    #gem 'turbolinks'
    #gem 'activevalidators'                                #ActiveValidators is a collection of off-the-shelf and tested ActiveModel/ActiveRecord validations. Validators for Dates, Email, ipv4 and ipv6, etc.
    #gem 'slip', :git => "https://github.com/func-i/slip.git" #A Ruby wrapper for the Slideshare.net API
    #gem 'unf'                                             #A wrapper library to bring Unicode Normalization Form support to Ruby/JRuby
    #gem 'httparty'                                        #For quick HTTP calls
    #gem 'twitter', '~> 5.5.1'                            #A Ruby interface to the Twitter API.
    #gem 'faraday'                                         #Faraday is an HTTP client lib that provides a common interface over many adapters (such as Net::HTTP) and embraces the concept of Rack middleware when processing the request/response cycle.
    #gem 'popcornjs-rails'                                 #Rails 3.1 asset-pipeline gem to provide popcorn.js support
    #gem 'handlebars-source', '~> 1.0.12'                  #Handlebars provides the power necessary to let you build semantic templates effectively with no frustration. Handlebars.js source code wrapper for (pre)compilation gems.
    #gem 'handlebars_assets'                               #Use handlebars.js templates with the Rails asset pipeline.
    #gem 'ember-rails'                                     #A javascript framework for building awesome UIs
    #gem 'ember-source', '1.1.0'                           #Ember.js source code wrapper for use with Ruby libs.
    #gem 'ember-data-source', '~> 1.0.0.beta.3'            #ember-data source code wrapper for use with Ruby libs.
    #gem 'ri_cal'                                          #New Rfc 2445 (iCalendar) gem for Ruby http://ri-cal.rubyforge.org/
    #gem 'high_voltage'                                    #Rails engine for static pages.
    
  #Production
    #gem 'unicorn'                                       #\Unicorn is an HTTP server for Rack applications designed to only serve fast clients on low-latency, high-bandwidth connections and take advantage of features in Unix/Unix-like kernels. Slow clients should only be served by placing a reverse proxy capable of fully buffering both the the request and response in between \Unicorn and slow clients.
    
  #Testing:
    #gem 'factory_girl_rails'                            #Currently not used. Used for creating standard datasets for testing
    #gem 'delorean'                                      #Delorean lets you travel in time with Ruby by mocking Time.now
    #gem 'faker'                                         #A library for generating fake data such as names, addresses, and phone numbers. 
    #gem 'jasmine-rails'                                 #Jasmine is a behavior-driven development framework for testing your JavaScript code
    #gem 'capybara'                                      #Test web applications by simulating how a real user would interact with your app
    #gem 'selenium-webdriver'                            #For testing as a user would see the application
    #gem 'email_spec'                                    #Collection of RSpec/MiniTest matchers and Cucumber steps for testing email in a ruby app using ActionMailer or Pony
    #gem 'webmock', :require=> false                     #Library for stubbing and setting expectations on HTTP requests in Ruby.
    
  #Development
    gem 'launchy'                                        #Launchy is the quickest way to get a landing page up and running that is functional and fully customizeable with a robust authentication system
    #gem 'debugger'                                      #ruby-debug is a fast implementation of the standard debugger debug.rb. The faster execution speed is achieved by utilizing a new hook in the Ruby C API.
    #gem 'html2haml'                                     #converts html or html + ERB files to haml
    #gem 'rails_layout'                                  #Use this gem to set up layout files for your choice of front-end framework. JW: Don't think that this is needed now..
    #gem 'rb-fchange', :require=>false                   #Gem which uses native windows methods for watching changes of file system. JW: Don't think this is required.
    #gem 'rb-fsevent', :require=>false                   #FSEvents API with signals handled (without RubyCocoa)
    #gem 'rb-inotify', :require=>false                   #This is a simple wrapper over the inotify Linux kernel subsystem for monitoring changes to files and directories. It uses the FFI gem to avoid having to compile a C extension.
    #gem 'debugger-ruby_core_source', '1.2.3'            #Retrieve ruby core source files
    
    #Should look into:
    #gem 'bullet'                                        #The Bullet gem is designed to help you increase your application's performance by reducing the number of queries it makes. It will watch your queries while you develop your application and notify you when you should add eager loading (N+1 queries)
    #gem 'guard-bundler'                                 #Guard watches files and automatially performs a command - Bundler watches the gemfile and runs bundler on changes
    #gem 'guard-rails'                                   #Guard watches files and automatially performs a command
    