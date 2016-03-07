Twinenyc::Application.routes.draw do
  resources :articles

  get "welcome/index"
  devise_for :users, controllers: {
    registrations: 'user/registrations'
  }
  get 'users/search' => 'users#search', as: :search_user
  resources :users do
    resources :collaborations
  end
  resources :twines, only: [:show, :new, :create]
  resources :sensors
  # resources :charges
  post 'readings' => 'readings#create'

  get 'users/:id/download' => 'users#download_pdf', as: :pdf_download
  get 'users/:id/live_update' => 'users#live_update'
  get 'users/:user_id/collaborations/:id/download' => 'users#download_pdf'
  get "demo" => "users#demo"

  get "complaints/query" => "complaint#query"
  get "complaints/" => "complaint#index"
  get "coldmap/" => "complaint#index"
  get "pilot" => "welcome#pilot"
  get "sponsors" => "welcome#sponsors"
  get "resources" => "welcome#resources"
  get "thankyou" => "welcome#thankyou"
  get "team" => "welcome#team"
  get "about" => "welcome#about"
  get "donate" => "welcome#giving_tuesday"
  get "how-it-works" => "welcome#how_it_works", as: :how_it_works
  get "giving-tuesday" => "welcome#giving_tuesday", as: :giving_tuesday
  get "nycbigapps" => "welcome#nycbigapps"
  get "vote-for-us" => "welcome#nycbigapps"
  get "judges" => "welcome#judges_welcome"
  get "judges_login/:last_name" => "users#judges_login"
  # get "demo" => "welcome#demo"
  get "press" => "welcome#press"
  get "blog" => "posts#index"
  get "calendar" => "welcome#calendar"
  root 'welcome#index'

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
