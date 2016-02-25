VirtualExhibition::Application.routes.draw do

  mount Resque::Server, :at => "/resque"
  
  get "robots.txt", to: "system#robots"
  get "sitemap.xml", to: "system#sitemap"

  get "events/dashboard", :to => "events#dashboard", as: :events_dashboard

  # Events
  get "events/all_events", :to => "events#all_events", as: :all_events
  get "events/all_events_public", :to => "events#all_events_public", as: :all_events_public
  get "events/:id/visit" => "events#visit", as: :event_visit

  # Booths
  get "booths/:id/about" => "booths#about", as: :booth_about
  get "booths/:id/leave-business-card" => "booths#leave_business_card", as: :booth_leave_business_card
  get "booths/:id/products" => "booths#products", as: :booth_products
  get "booths/:id/literature" => "booths#literature", as: :booth_literature
  get "booths/:id/contact-info" => "booths#contact_info", as: :booth_contact_info
  get "booths/:id/chat-widget" => "booths#chat_widget", as: :booth_chat
  post "booths/:id/send-message" => "booths#send_message", as: :booth_send_message
  post "booths/:id/send-business-card" => "booths#send_business_card", as: :booth_send_business_card
  get "booths/:id" => "booths#visit", as: :booths_visit
  get "booths/:id/visit" => "booths#visit"
  get "booths/:id/company_website" => "booths#company_website", as: :booth_record_company_website
  get "booths/:id/facebook" => "booths#facebook", as: :booth_record_facebook
  get "booths/:id/twitter" => "booths#twitter", as: :booth_record_twitter
  get "booths/:id/linkedin" => "booths#linkedin", as: :booth_record_linkedin
  get "booths/:id/googleplus" => "booths#googleplus", as: :booth_record_googleplus
  get "booths/:id/add_promotion_to_cart" => "booths#add_promotion_to_cart", as: :booth_add_promotion_to_cart
  get "booths/:id/show" => "booths#show", as: :show_booth

  get "privacy", :to => "events#privacy", as: :privacy
  get "invite_users", :to => "users#invite_users", as: :invite_users
  get "read_all_booth_user_chats", :to => "chats#read_all_booth_user_chats", as: :read_all_booth_user_chats
  match "users/export_users_to_csv_by_event", :to => "users#export_users_to_csv_by_event", as: :user_export_csv_status, via: [:get, :post]
  get "users/export_users_to_csv", :to => "users#export_users_to_csv", as: :user_export_users_to_csv

  post 'users/create_user' => 'users#create_user', as: :create_user
  get 'users/import/new' => 'users#import_new', as: :import_users
  post 'users/import/process' => 'users#import_process', as: :import_users_process

  get 'system/job_status' => 'system#job_status', as: :system_job_status
  get "system/update_job_status", to: "system#update_job_status", as: :update_job_status
  

  #Videos
  get 'contents/:id/preview', to: "contents#preview", as: :preview_content
  get 'contents/:id/view', to: "contents#view", as: :view_content
  get 'contents/:id/sponsor', to: "contents#sponsor", as: :sponsor_content
  

  match "hall/:id" => "halls#visit", as: :hall_visit, via: [:get, :post]
  match "hall/:id/visit" => "halls#visit", via: [:get, :post]
  get "hall/:id/content/:content_id" => "halls#visit", as: :hall_view_content
  #Two legacy routes to preserve existing links
  match "venues/:old_venue_id/hall/:id" => "halls#visit", via: [:get, :post]
  match "venues/:old_venue_id/hall/:id/visit" => "halls#visit", via: [:get, :post]

  get '/templates/template_sub_types/:template_type', to: "templates#template_sub_type", as: :template_sub_types
  
  post '/promotions/:promotion_id/generate_codes', to: "promotion_codes#generate_codes"
  post '/promotions/:promotion_id/import_codes', to: "promotion_codes#import_codes"
  delete '/promotions/:promotion_id/promotion_codes', to: "promotion_codes#destroy_all", as: :destroy_all_promotion_codes

  get '/shopping_cart', to: "shopping_carts#visit", as: :shopping_cart
  get '/shopping_cart/redeem', to: "shopping_carts#redeem", as: :redeem_shopping_cart
  get '/shopping_cart_item/:shopping_cart_item/remove', to: "shopping_carts#remove_item", as: :remove_shopping_cart_item
  
  
  resources :products, :templates, :chats, :moderated_chats
  resources :events, shallow: true do
    match "hall/:id/visit" => "halls#visit", as: :hall_visit, via: [:get, :post]
    get "structure", :to => "events#venue_structure"
    get "promotions/export", :to => "promotion_codes#export_codes"
    resources :tags, :contents, :promotions
    resources :halls do
      resources :booths do
        resources :chats
      end
      member do
        get "content-list"
      end
    end
    resources :booths do
      resources :chats, :promotions
      get "promotions/export", :to => "promotion_codes#export_codes"
    end
    resources :promotions, shallow: true do
      get "export", :to => "promotion_codes#export_codes"
      resources :promotion_codes
    end
  end


  root :to => 'events#dashboard'

  devise_for :users, :controllers => {confirmations: 'confirmations', :registrations => "registrations", sessions: "sessions", :omniauth_callbacks => "omniauth_callbacks"}
  
  resources :users
  
  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "users/sign_up/:id", :to => "registrations#new", as: :user_sign_up
    post "users/social-register", :to => "registrations#social_register", as: :social_register
  end
end
