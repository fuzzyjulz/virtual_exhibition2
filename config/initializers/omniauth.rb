#Rails.application.config.middleware.use OmniAuth::Builder do
#  #Unsure if this is actually used...
#
#	provider :developer unless Rails.env.production?
#  	provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
#  	provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
#           :scope => 'email,user_birthday,read_stream', :display => 'popup'
#  	provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'],
#            :scope => 'r_fullprofile r_emailaddress r_network'
#  	provider :google_oauth2, ENV["GOOGLE_KEY"], ENV["GOOGLE_SECRET"],
#  	{
#      :name => "google",
#      :scope => "userinfo.email, userinfo.profile, plus.me, http://gdata.youtube.com",
#      :prompt => "select_account",
#      :image_aspect_ratio => "square",
#      :image_size => 50
#    }
#end
