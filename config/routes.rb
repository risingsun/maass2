Maass2::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "users"}
  resources :users
  resources :events,:has_many => [:comments]
  resources :nominations
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
    end
    resources :announcements
  end
  resources :forums do
    resources :forum_topics
  end
  resources :votes
  resources :feedbacks
  resources :profiles do

    resource :friendship, :only => [:create, :update, :destroy]

    resources :friends
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
      get 'search_poll', :on => :member
    end

    resources :feed_items
    resources :invitations
    resources :nominations,:except => [:index]

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
  end

  resources :comments
  
  resources :student_checks do
    get 'view_year_students', :on=> :collection
    post 'send_bulk_invite', :on=> :collection
    post 'send_invite', :on=> :member
  end

  root :to=>"homes#index"

  resources :homes do
    get 'polls', :on => :member
  end

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
