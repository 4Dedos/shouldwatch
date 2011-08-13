Shouldwatch::Application.routes.draw do
  match '/auth/:provider/callback', :to => 'sessions#callback'
  match '/signout' => 'sessions#destroy', :as => :signout


  resources :movies do
    get 'search', :on => :collection
  end
  
  get 'home/movie'
  get 'home/first_visit'
  get 'home/welcome_guest'

  root :to => "home#index"


  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

