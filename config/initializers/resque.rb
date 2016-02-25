if Rails.env.production? or Rails.env.staging? or Rails.env.vctest?
  uri = URI.parse(ENV["REDISTOGO_URL"])
  redis_credentials = {:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true}
elsif Rails.env.development?
	redis_credentials = {:host => "localhost", :port => 6379}
elsif Rails.env.test? #dummy credentials for test servers
	redis_credentials = nil
end

unless redis_credentials.nil?
  Resque.redis = Redis.new(redis_credentials)
  Resque::Plugins::Status::Hash.expire_in = (24 * 60 * 60) # 24hrs in seconds
  Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
end
