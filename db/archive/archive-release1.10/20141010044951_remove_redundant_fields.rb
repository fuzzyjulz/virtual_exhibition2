class RemoveRedundantFields < ActiveRecord::Migration
  def change
    remove_column :events, :user_id
    remove_column :events, :whats_new
    remove_column :events, :personal_map
    remove_column :events, :display_webcast_rating
    remove_column :events, :display_other_content_rating
    remove_column :events, :closed_event_redirect
    remove_column :events, :display_on_demand_status
    remove_column :events, :display_original_broadcast_date
    remove_column :events, :venue_reports_url
    remove_column :events, :support_message
    remove_column :events, :venue_comments
    remove_column :events, :colour
    
    remove_column :halls, :colour
    remove_column :halls, :greeting
    remove_column :halls, :greeting_type
    remove_column :halls, :greeting_enable
    remove_column :halls, :jumbotron
    remove_column :halls, :jumbotron_enable
    remove_column :halls, :sponsors
    remove_column :halls, :hash_tags
    remove_column :halls, :hall_type
    remove_column :halls, :background_id
    
    remove_column :booths, :social_media
    remove_column :booths, :email
    remove_column :booths, :public_chat
    remove_column :booths, :twitter_roll
    remove_column :booths, :twitter_hash_tag
    remove_column :booths, :survey_url
    remove_column :booths, :prize_giveaway_description
    remove_column :booths, :newsletter_description
    remove_column :booths, :greeting_image_id
    remove_column :booths, :greeting_audio_id
    remove_column :booths, :greeting_video_id
    remove_column :booths, :greeting_video
    remove_column :booths, :greeting_virtual_host_id
    remove_column :booths, :booth_package
    remove_column :booths, :twitter_url
    remove_column :booths, :linkedin_url
    remove_column :booths, :facebook_url
    remove_column :booths, :greeting_video_enabled
    
    remove_column :templates, :jumbotron_available
    
    remove_column :products, :image_id
    remove_column :products, :request_info
    remove_column :products, :email_notification
    remove_column :products, :emails
    remove_column :products, :product_url_type

  end
end
