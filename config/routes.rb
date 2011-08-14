Shouldwatch::Application.routes.draw do
  match '/auth/:provider/callback', :to => 'sessions#callback'
  match '/signout' => 'sessions#destroy', :as => :signout

  resources :movies do
    get 'search', :on => :collection
    get 'watch_this', :on => :member
    post 'recommend', :on => :member
    post 'accept_recommendation', :on => :member
    post 'reject_recommendation', :on => :member
    post 'order', :on => :collection
  end

  resources :watchlist, :only => [:create]

  resources :recommendations, :only => [:show, :create], :path => 'r'

  match '/welcome', :to => "home#welcome"
  match '/about', :to => "home#about"
  root :to => "home#index"


  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  match '/:id', :to => "users#show", :as => 'user_profile'
end

