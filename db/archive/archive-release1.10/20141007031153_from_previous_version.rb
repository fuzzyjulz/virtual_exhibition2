class FromPreviousVersion < ActiveRecord::Migration
  def change
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    enable_extension "hstore"
    enable_extension "pg_stat_statements"
  
    create_table "admins", force: true do |t|
      t.string   "email",                  default: "", null: false
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
    add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  
    create_table "auth_models", force: true do |t|
      t.string "name"
      t.string "code"
    end
  
    create_table "auth_models_venues", id: false, force: true do |t|
      t.integer "venue_id",      null: false
      t.integer "auth_model_id", null: false
    end
  
    add_index "auth_models_venues", ["auth_model_id", "venue_id"], name: "index_auth_models_venues_on_auth_model_id_and_venue_id", using: :btree
    add_index "auth_models_venues", ["venue_id", "auth_model_id"], name: "index_auth_models_venues_on_venue_id_and_auth_model_id", using: :btree
  
    create_table "booths", force: true do |t|
      t.string   "name"
      t.string   "company_website"
      t.text     "social_media"
      t.text     "contact_info"
      t.string   "email"
      t.text     "about_us"
      t.integer  "greeting_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "event_id"
      t.boolean  "public_chat"
      t.boolean  "twitter_roll"
      t.string   "twitter_hash_tag"
      t.string   "survey_url"
      t.text     "prize_giveaway_description"
      t.text     "newsletter_description"
      t.integer  "greeting_image_id"
      t.integer  "greeting_audio_id"
      t.integer  "greeting_video_id"
      t.integer  "greeting_virtual_host_id"
      t.boolean  "display_mode"
      t.integer  "booth_package"
      t.integer  "user_id"
      t.string   "greeting_video"
      t.string   "twitter_url"
      t.string   "linkedin_url"
      t.string   "facebook_url"
      t.text     "top_message"
      t.integer  "template_id"
      t.integer  "hall_id"
      t.boolean  "greeting_video_enabled"
      t.text     "ticker_message"
      t.string   "button1_label"
      t.text     "button1_content"
      t.integer  "publish_status"
    end
  
    add_index "booths", ["event_id"], name: "index_booths_on_event_id", using: :btree
    add_index "booths", ["greeting_audio_id"], name: "index_booths_on_greeting_audio_id", using: :btree
    add_index "booths", ["greeting_image_id"], name: "index_booths_on_greeting_image_id", using: :btree
    add_index "booths", ["greeting_video_id"], name: "index_booths_on_greeting_video_id", using: :btree
    add_index "booths", ["greeting_virtual_host_id"], name: "index_booths_on_greeting_virtual_host_id", using: :btree
    add_index "booths", ["hall_id"], name: "index_booths_on_hall_id", using: :btree
    add_index "booths", ["template_id"], name: "index_booths_on_template_id", using: :btree
    add_index "booths", ["user_id"], name: "index_booths_on_user_id", using: :btree
  
    create_table "booths_contents", id: false, force: true do |t|
      t.integer "booth_id",   null: false
      t.integer "content_id", null: false
    end
  
    add_index "booths_contents", ["booth_id", "content_id"], name: "index_booths_contents_on_booth_id_and_content_id", using: :btree
    add_index "booths_contents", ["content_id", "booth_id"], name: "index_booths_contents_on_content_id_and_booth_id", using: :btree
  
    create_table "booths_products", id: false, force: true do |t|
      t.integer "booth_id",   null: false
      t.integer "product_id", null: false
    end
  
    add_index "booths_products", ["booth_id", "product_id"], name: "index_booths_products_on_booth_id_and_product_id", using: :btree
    add_index "booths_products", ["product_id", "booth_id"], name: "index_booths_products_on_product_id_and_booth_id", using: :btree
  
    create_table "booths_tags", id: false, force: true do |t|
      t.integer "booth_id", null: false
      t.integer "tag_id",   null: false
    end
  
    add_index "booths_tags", ["booth_id", "tag_id"], name: "index_booths_tags_on_booth_id_and_tag_id", using: :btree
    add_index "booths_tags", ["tag_id", "booth_id"], name: "index_booths_tags_on_tag_id_and_booth_id", using: :btree
  
    create_table "chats", force: true do |t|
      t.text     "message"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "chattable_id"
      t.string   "chattable_type"
      t.integer  "from_user_id"
      t.integer  "to_user_id"
      t.boolean  "qna"
      t.boolean  "approved"
      t.boolean  "read"
    end
  
    create_table "contents", force: true do |t|
      t.string   "name"
      t.string   "short_desc"
      t.text     "description"
      t.boolean  "featured"
      t.string   "content_type"
      t.string   "external_id"
      t.integer  "sponsor_booth_id"
      t.integer  "owner_user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "venue_id"
      t.integer  "privacy"
      t.integer  "duration"
      t.string   "thumbnail_url"
    end
  
    create_table "contents_halls", id: false, force: true do |t|
      t.integer "hall_id",    null: false
      t.integer "content_id", null: false
    end
  
    add_index "contents_halls", ["content_id", "hall_id"], name: "index_contents_halls_on_content_id_and_hall_id", using: :btree
    add_index "contents_halls", ["hall_id", "content_id"], name: "index_contents_halls_on_hall_id_and_content_id", using: :btree
  
    create_table "contents_tags", id: false, force: true do |t|
      t.integer "content_id", null: false
      t.integer "tag_id",     null: false
    end
  
    add_index "contents_tags", ["content_id", "tag_id"], name: "index_contents_tags_on_content_id_and_tag_id", using: :btree
    add_index "contents_tags", ["tag_id", "content_id"], name: "index_contents_tags_on_tag_id_and_content_id", using: :btree
  
    create_table "events", force: true do |t|
      t.string   "name"
      t.string   "status"
      t.datetime "start"
      t.datetime "finish"
      t.string   "event_url"
      t.string   "event_reports_url"
      t.string   "logo1"
      t.string   "logo2"
      t.string   "top_bar_background"
      t.string   "colour"
      t.boolean  "publish_event"
      t.string   "event_image"
      t.text     "description"
      t.string   "search_keywords"
      t.string   "closed_event_redirect"
      t.text     "comments"
      t.integer  "venue_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "hall_id"
    end
  
    add_index "events", ["hall_id"], name: "index_events_on_hall_id", using: :btree
    add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree
  
    create_table "events_users", id: false, force: true do |t|
      t.integer "event_id", null: false
      t.integer "user_id",  null: false
    end
  
    add_index "events_users", ["event_id", "user_id"], name: "index_events_users_on_event_id_and_user_id", using: :btree
    add_index "events_users", ["user_id", "event_id"], name: "index_events_users_on_user_id_and_event_id", using: :btree
  
    create_table "halls", force: true do |t|
      t.string   "name"
      t.integer  "template_id"
      t.integer  "background_id"
      t.string   "colour"
      t.string   "greeting"
      t.string   "greeting_type"
      t.boolean  "greeting_enable"
      t.string   "jumbotron"
      t.boolean  "jumbotron_enable"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "venue_id"
      t.string   "ancestry"
      t.string   "sponsors"
      t.string   "hall_type"
      t.string   "hash_tags"
      t.integer  "welcome_video_content_id"
      t.string   "title"
      t.text     "description"
    end
  
    add_index "halls", ["ancestry"], name: "index_halls_on_ancestry", using: :btree
    add_index "halls", ["venue_id"], name: "index_halls_on_venue_id", using: :btree
  
    create_table "moderated_chats", force: true do |t|
      t.text     "message"
      t.integer  "webcast_id"
      t.integer  "from_user_id"
      t.integer  "to_user_id"
      t.boolean  "approved"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "moderated_chats", ["webcast_id"], name: "index_moderated_chats_on_webcast_id", using: :btree
  
    create_table "products", force: true do |t|
      t.string   "name"
      t.text     "description"
      t.string   "product_url"
      t.integer  "image_id"
      t.boolean  "request_info"
      t.boolean  "email_notification"
      t.string   "emails"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "product_url_type"
    end
  
    add_index "products", ["image_id"], name: "index_products_on_image_id", using: :btree
  
    create_table "roles", force: true do |t|
      t.string   "name"
      t.integer  "resource_id"
      t.string   "resource_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    add_index "roles", ["name"], name: "index_roles_on_name", using: :btree
  
    create_table "tags", force: true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "featured"
      t.integer  "venue_id"
    end
  
    create_table "templates", force: true do |t|
      t.string   "name"
      t.boolean  "jumbotron_available"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "template_type"
      t.string   "template_sub_type"
    end
  
    create_table "uploaded_files", force: true do |t|
      t.integer  "imageable_id"
      t.string   "imageable_type"
      t.string   "assets_file_name"
      t.string   "assets_content_type"
      t.integer  "assets_file_size"
      t.datetime "assets_updated_at"
      t.string   "image_type"
      t.integer  "image_width"
      t.integer  "image_height"
    end
  
    create_table "users", force: true do |t|
      t.string   "email",                               default: "", null: false
      t.string   "encrypted_password",                  default: ""
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                       default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "unconfirmed_email"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "title"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "position"
      t.string   "work_phone"
      t.string   "company"
      t.string   "provider"
      t.string   "uid"
      t.datetime "last_seen"
      t.string   "invitation_token"
      t.datetime "invitation_created_at"
      t.datetime "invitation_sent_at"
      t.datetime "invitation_accepted_at"
      t.integer  "invitation_limit"
      t.integer  "invited_by_id"
      t.string   "invited_by_type"
      t.string   "state"
      t.string   "industry"
      t.string   "mobile"
      t.string   "origin"
      t.boolean  "terms"
      t.string   "status"
      t.text     "booth_closed_message"
      t.integer  "invitations_count"
      t.string   "interested_topic",       limit: 2000
      t.string   "external_avatar_url"
    end
  
    add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  
    create_table "users_roles", id: false, force: true do |t|
      t.integer "user_id", null: false
      t.integer "role_id", null: false
    end
  
    add_index "users_roles", ["role_id", "user_id"], name: "index_users_roles_on_role_id_and_user_id", using: :btree
    add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  
    create_table "venues", force: true do |t|
      t.string   "name"
      t.integer  "user_id"
      t.string   "colour"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "logo"
      t.boolean  "whats_new"
      t.boolean  "personal_map"
      t.boolean  "display_webcast_rating"
      t.boolean  "display_other_content_rating"
      t.boolean  "closed_event_redirect"
      t.integer  "event_redirect_id"
      t.boolean  "display_on_demand_status"
      t.boolean  "display_original_broadcast_date"
      t.string   "venue_reports_url"
      t.text     "support_message"
      t.text     "venue_comments"
      t.string   "main_sponsor_url"
      t.string   "sponsor_tagline"
      t.string   "event_welcome_heading"
      t.text     "event_welcome_text"
      t.integer  "privacy"
      t.boolean  "can_register"
    end
  
    add_index "venues", ["user_id"], name: "index_venues_on_user_id", using: :btree
  
    create_table "webcasts", force: true do |t|
      t.string   "name"
      t.integer  "hall_id"
      t.string   "webcast_type"
      t.string   "media_type"
      t.integer  "user_id"
      t.string   "details"
      t.integer  "template_id"
      t.string   "background_colour"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "start"
      t.string   "duration"
      t.datetime "finish"
      t.hstore   "widget_locations"
    end
  
    add_index "webcasts", ["hall_id"], name: "index_webcasts_on_hall_id", using: :btree
    add_index "webcasts", ["template_id"], name: "index_webcasts_on_template_id", using: :btree
    add_index "webcasts", ["user_id"], name: "index_webcasts_on_user_id", using: :btree
  end
end