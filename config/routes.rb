Lawdingo::Application.routes.draw do
  match 'sitemap.xml' => 'sitemaps#sitemap'

  resources :appointments, :only => [:create]

  resources :clients, :only => [:new, :create]

  namespace :framey do
    resources :videos
  end
  post "framey/callback" => "framey/videos#callback"

  resources :lawyers, :only => [:new, :create]
  match '/apply' => "lawyers#new", :as => :new_lawyer

  resources :questions
  resources :reviews
  resources :schools
  resources :inquiries, only: :show
  resources :bids, only: :create
  get "password_resets/new"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  match 'attorneys/:id/call-payment' => 'attorneys#call_payment', 
    as: :call_payment
  match 'attorneys/:id/*slug' => 'attorneys#show', as: :attorney
  match '/paid' => "stripe#subscribe_lawyer", :as => :subscribe_lawyer
  
  resources :users do
    # daily_hours for this user (lawyer)
    resources :daily_hours, :only => [:index] do
      # we use a put to update/create the entire collection
      collection do
        put "update"
      end
    end
    
    resources :offerings, shallow: true

    put 'image_upload'
    get 'chat_session'
    get 'onlinestatus'
  end

  resources :sessions
  resources :password_resets
  resources :conversations do
    get 'review'
    get 'summary'
  end
  match 'conversations/:conversation_id/summary(/:form)' => "conversations#summary", as: :conversation_summary

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  namespace :admin do
    #     # Directs /admin/products/* to Admin::ProductsController
    #     # (app/controllers/admin/products_controller.rb)
    resources :questions, only: [:index, :show] do
      post "send_inquiry", on: :collection
    end
    resources :clients
    resources :lawyers do
      get 'account_approval'
      get 'hm_image'
    end
    resources :clsessions
    resources :pages
    resources :homepage_images
    resources :practice_areas
  end

  match 'modparam' =>'users#update_parameter', :as =>:update_parameter
  match "/users/create_lawyer_request", to: "users#create_lawyer_request", as: :create_lawyer_request
  match '/user/sessions/:user_id' =>"users#session_history", :as =>:user_session_history
  match '/users/:user_id/daily_hours' =>"users#daily_hours", :as =>:user_daily_hours
  match '/users/:user_id' =>"users#account_information", :as =>:user_account_information
  match '/about' =>"pages#show", :name =>'about', :as =>:about_page
  match '/about_attorneys' =>"pages#about_attorneys", :name =>'about_attorneys', :as =>:about_attorneys
  match '/terms' =>"pages#terms_of_use", :name =>'terms', :as =>:terms_page
  match '/pricing_process' =>"pages#pricing_process", :name =>'pricing_process', :as =>:pricing_process
  match '/pricing_process_activation' =>"pages#pricing_process_activation", :name =>'pricing_process_activation', :as =>:pricing_process_activation
  match '/process_signup' =>"pages#process_signup", :name =>'process_signup', :as =>:process_signup
  
  match '/login' => "sessions#new", :as => :login
  match '/logout' => "sessions#destroy", :as => :logout
  match '/details' => 'users#payment_info', :as => :card_detail
  match '/welcome' => 'users#welcome_lawyer', :as => :welcome
  match '/Register' => 'users#register_for_videochat', :as => :register_videochat
  match '/find_friend' => 'users#find_remote_user_for_videochat', :as => :find_remote_user
  match '/UpdateBusyStatus' => 'users#update_busy_status', :as => :UpdateBusyStatus
  match '/ScheduleSession' => 'users#send_email_to_lawyer', :as => :schedule_session
  match '/UpdateOnlineStatus' => 'users#update_online_status', :as => :UpdateOnlineStatus
  match '/twilio/phonecall' => 'users#start_phone_call', :as => :phonecall
  match '/twilio/createcall' => 'users#create_phone_call', :as => :create_call
  match '/twilio/endcall' => 'users#end_phone_call', :as => :endcall
  match '/twilio/voice' => 'twilio#twilio_return_voice', :as => :twilio_voice
  match '/twilio/process_gather' => 'twilio#process_gather', :as => :process_gather
  match '/twilio/fallback' => 'twilio#fallback', :as => :twilio_fallback
  match '/twilio/callback' => 'twilio#callbackstatus', :as => :twilio_callback
  match '/twilio/dial_callback' => 'twilio#dial_callback', :as =>:dial_callback
  match '/search' => 'users#search'
  match '/search/populate_specialities' => 'search#populate_specialities'
  # Temporary route for the next home page
  match '/search/populate_specialities_next' => 'search#populate_specialities_next'
  match '/search/filter_results' => 'search#filter_results'
  match '/search/carsousel_images' =>'search#get_homepage_lawyers'
  match '/updatePaymentInfo' => 'users#update_payment_info'
  match '/CheckPaymentInfo' => 'users#has_payment_info'
  match '/CheckCallStatus' => 'users#check_call_status'
  match '/UpdateCallStatus' => 'users#update_call_status'
  # match '/results' => "users#home", :as => :results

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  match '/admin' =>"users#show", :as =>:admin_home
  #root :to => 'users#home'
  
  match '/lawyers/:service_type(/:state)' => 'users#home'
  match '/lawyers/:service_type/:state(/:practice_area)' => 'users#home'
  match '/lawyers/:service_type/:state/:practice_area(/:practice_subarea)' => 'users#home'
  match '/auto-detect/detect-state' => 'users#detect_state'
  match '/lawyers' => 'users#home'
  match '/learnmore' => 'users#learnmore'
  root :to => 'users#landing_page'

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end

  match '/LoginByApp' => 'sessions#login_by_app'
  match '/UpdateOnlineByApp' => 'sessions#set_status_by_app'
end
