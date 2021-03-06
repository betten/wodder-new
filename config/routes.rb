WodderNew::Application.routes.draw do

  get "comments/create"

  get "comments/destroy"

  resources :users do
    member do
      get 'wods'
    end

    collection do
      get 'me'
      get 'signup'
      post 'signin'
      get 'signout'
    end
  end

  match '/users/me', :as => :current_user
  match '/users/me/edit' => 'users#edit', :as => :edit_current_user

  match '/donations' => 'users#donate', :as => :donate

  resources :wods do
    resources :comments
    member do
      get 'up_vote'
      get 'save'
      get 'unsave'
    end

    collection do
      get 'user'
      get 'gym'
      get 'saved'
      get 'rss'
    end
  end

  resources :gyms do
    member do
    end

    collection do
      get 'add'
      get 'admin'
      post 'test_xpath'
    end
  end

  match "jobs/update" => "jobs#update_all", :as => :jobs_update
  match "jobs/update/:id" => "jobs#update", :as => :job_update
  match "jobs/clear" => "jobs#clear_all", :as => :jobs_clear
  match "jobs/clear/:id" => "jobs#clear", :as => :job_clear

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

  root :to => "wods#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
