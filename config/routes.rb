Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      # User routes
      post "users/sign_up" => "users#create"
      get "users" => "users#index"
      delete "users/delete/:id" => "users#destroy"
      put "users/update" => "users#update"
      get "users/:id" => "users#show"

      resources :users, only: [ :index, :show, :create, :update, :destroy ]

      # Authentication routes
      post "login" => "authentication#login"
      delete "logout" => "authentication#logout"
      get "current_user_info" => "authentication#current_user_info"

      # Sport routes
      get "sports" => "sports#index"
      post "sports" => "sports#create"
      put "sports" => "sports#update"
      delete "sports" => "sports#destroy"
      get "sports/:id" => "sports#show"

      # Equipment routes
      get "equipment" => "equipment#index"
      post "equipment" => "equipment#create"
      put "equipment/:id" => "equipment#update"
      delete "equipment" => "equipment#destroy"
      get "equipment/:id" => "equipment#show"
    end
  end
end
