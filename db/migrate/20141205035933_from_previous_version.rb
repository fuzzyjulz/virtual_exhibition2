class FromPreviousVersion < ActiveRecord::Migration
  def change
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    enable_extension "hstore"
    enable_extension "pg_stat_statements"
  
    create_table "auth_models", force: true do |t|
      t.string "name"
      t.string "code"
    end
  
    create_table "auth_models_events", id: false, force: true do |t|
      t.integer "event_id",      null: false
      t.integer "auth_model_id", null: false
    end
  
    add_index "auth_models_events", ["auth_model_id", "event_id"], name: "index_auth_models_events_on_auth_model_id_and_event_id", using: :btree
    add_index "auth_models_events", ["event_id", "auth_model_id"], name: "index_auth_models_events_on_event_id_and_auth_model_id", using: :btree
  
    create_table "booths", force: true do |t|
      t.string   "name"
      t.string   "company_website"
      t.text     "contact_info"
      t.text     "about_us"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "display_mode"
      t.integer  "user_id"
      t.text     "top_message"
      t.integer  "template_id"
      t.integer  "hall_id"
      t.text     "ticker_message"
      t.string   "button1_label"
      t.text     "button1_content"
      t.integer  "publish_status"
      t.integer  "event_id"
      t.text     "related_sponsor_tagline"
      t.string   "tagline"
      t.integer  "promotion_type"
      t.string   "promotion_url"
      t.string   "followus_url_twitter"
      t.string   "followus_url_facebook"
      t.string   "followus_url_linkedin"
      t.string   "followus_url_googleplus"
      t.text     "booth_list_message"
    end
  
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
      t.integer  "event_id"
      t.integer  "privacy"
      t.integer  "duration"
      t.string   "thumbnail_url"
      t.integer  "order_index"
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
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "logo"
      t.integer  "event_redirect_id"
      t.string   "main_sponsor_url"
      t.string   "sponsor_tagline"
      t.string   "event_welcome_heading"
      t.text     "event_welcome_text"
      t.integer  "privacy"
      t.boolean  "can_register"
      t.datetime "start"
      t.datetime "finish"
      t.string   "event_url"
      t.integer  "landing_hall_id"
      t.text     "main_tagline"
      t.text     "additional_info"
      t.string   "topics_title"
      t.string   "keynotes_title"
      t.text     "signup_panel"
    end
  
    create_table "events_users", id: false, force: true do |t|
      t.integer "user_id",  null: false
      t.integer "event_id", null: false
    end
  
    add_index "events_users", ["event_id", "user_id"], name: "index_events_users_on_event_id_and_user_id", using: :btree
    add_index "events_users", ["user_id", "event_id"], name: "index_events_users_on_user_id_and_event_id", using: :btree
  
    create_table "halls", force: true do |t|
      t.string   "name"
      t.integer  "template_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "event_id"
      t.string   "ancestry"
      t.integer  "welcome_video_content_id"
      t.string   "title"
      t.text     "description"
      t.integer  "publish_status"
    end
  
    add_index "halls", ["ancestry"], name: "index_halls_on_ancestry", using: :btree
    add_index "halls", ["event_id"], name: "index_halls_on_event_id", using: :btree
  
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
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
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
      t.integer  "event_id"
      t.string   "tag_type"
      t.text     "description"
      t.string   "related_sponsors_text"
    end
  
    create_table "templates", force: true do |t|
      t.string   "name"
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
  end
end
