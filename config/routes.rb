Twinenyc::Application.routes.draw do
  root "welcome#index"

  devise_for :users, controllers: {
    registrations: 'user/registrations'
  }

  resources :articles
  resources :sensors
  resources :twines, only: [:show, :new, :create]

  get 'users/search' => 'users#search', as: :search_user
  resources :users do
    resources :collaborations
    collection do
      get "edit_password"
      patch "update_password"
    end
  end

  resources :readings, only: [:index, :create]

  get 'addresses' => 'users#addresses'
  get 'users/:id/download' => 'users#download_pdf', as: :pdf_download
  get 'users/:id/live_update' => 'users#live_update'
  get 'users/:user_id/collaborations/:id/download' => 'users#download_pdf'

  get "demo" => "users#demo"
  get "judges_login/:last_name" => "users#judges_login"

  get "coldmap" => "complaint#index"
  get "complaints/query" => "complaint#query"
  get "complaints/" => "complaint#index"

  get "blog" => "posts#index"

  get "about" => "welcome#about"
  get "donate" => "welcome#donate"
  get "giving-tuesday" => "welcome#giving_tuesday", as: :giving_tuesday
  get "how-it-works" => "welcome#how_it_works", as: :how_it_works
  get "judges" => "welcome#judges_welcome"
  get "nycbigapps" => "welcome#nycbigapps"
  get "pilot" => "welcome#pilot"
  get "press" => "welcome#press"
  get "resources" => "welcome#resources"
  get "sponsors" => "welcome#sponsors"
  get "team" => "welcome#team"
  get "thankyou" => "welcome#thankyou"
  get "video" => "welcome#video"
  get "vote-for-us" => "welcome#nycbigapps"

  namespace :admin do
    resources :buildings
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
