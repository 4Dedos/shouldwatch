Shouldwatch::Application.routes.draw do
  match '/auth/:provider/callback', :to => 'sessions#callback'
  match '/signout' => 'sessions#destroy', :as => :signout

  resources :movies do
    get 'search', :on => :collection
  end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

