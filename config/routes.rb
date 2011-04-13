Maass2::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "users"}

  match "/auth/:provider/callback" => "authentications#create"
  match "/auth/failure" => "authentications#failure"
  resources :authentications
  resources :users  
  resources :nominations
  resources :votes
  resources :feedbacks
  resources :comments

  namespace :admin do
    resources :events do
      get 'rsvp', :on => :member
      get 'attending_members', :on => :member
      get 'not_attending_members', :on => :member
      get 'may_be_attending_members', :on => :member
      get 'event_members', :on => :member
      post 'send_event_mail', :on => :member
    end
    resources :home do
      get 'greetings', :on => :member
      get 'blogs', :on => :member
      get 'send_blog', :on=> :member
      get 'google_map_locations', :on => :member
    end
    resources :preferences do
      get 'new_title', :on=> :collection
      put 'add_title', :on=> :collection
      get 'edit_title', :on=> :collection
      put 'update_title', :on=> :collection
      delete 'delete_title', :on => :member
      get 'new_house_name', :on=> :collection
      put 'add_house_name', :on=> :collection
      get 'edit_house_name', :on=> :collection
      put 'update_house_name', :on=> :collection      
      delete 'delete_house_name', :on => :member
    end
    resources :announcements
    resources :site_contents
  end

  resources :forums do
    resources :forum_topics do
      resources :forum_posts
    end
  end

  resources :profiles do
    resource :friendship, :only => [:create, :update, :destroy]
    resources :friends
    resources :feed_items
    resources :invitations
    resources :nominations,:except => [:index]
    resources :photos
    resources :messages do
      get 'direct_message', :on => :collection
      get 'sent_messages', :on => :collection
      get 'reply_message', :on => :member
      post 'delete_messages', :on => :collection
    end
    resources :blogs  do
      get 'blog_archive', :on => :member
      get 'show_blogs', :on => :member
    end
    resources :polls do
      get 'poll_close', :on => :member      
    end
    post 'load_profile', :on => :collection
    get 'edit_account', :on => :member
    get 'search', :on=>:collection
    get 'friend_search', :on=>:collection
    get 'active_user', :on => :member
    get 'user_friends', :on => :member
    get 'batch_mates', :on => :member
    get 'batch_details', :on=>:collection
    get 'search_group', :on=>:collection
    get 'search_location', :on=>:collection
    get 'sample_ajax', :on => :member
  end
  resources :student_checks do
    get 'view_year_students', :on=> :collection
    post 'send_bulk_invite', :on=> :collection
    post 'send_invite', :on=> :member
  end
  resources :homes do
    get 'photo_gallery', :on => :collection
  end

  resources :events do
    get 'alumni_friends', :on=> :collection
  end

  root :to=>"homes#index"
  match '/edit',  :to => 'profiles#edit'
  match '/new',  :to => 'blogs#new'
  match '/ue/:hash/:profile_id', :to=> 'profiles#update_email', :as=>:update_email
  #  match '/blog_archive/:month/:year', :to => 'blogs#blog_archive'

  #  match '/user/:user_id/profile/:id',  :to => 'profiles#show'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end