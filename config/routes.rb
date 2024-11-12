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
      put "users/:id" => "users#update"
      get "users/:id" => "users#show"
      get "users/:id/loans" => "users#get_loans"

      resources :users, only: [ :index, :show, :create, :update, :destroy ]

      # Authentication routes
      post "login" => "authentication#login"
      delete "logout" => "authentication#logout"
      get "current_user_info" => "authentication#current_user_info"

      # Sport routes
      get "sports" => "sports#index"
      post "sports" => "sports#create"
      put "sports/:id" => "sports#update"
      delete "sports" => "sports#destroy"
      get "sports/:id" => "sports#show"

      # Equipment routes
      resources :equipment do
        collection do
          get "available", to: "equipment#available"
        end
      end

      # Loan routes
      resources :loans do
        collection do
          put "return_all", to: "loans#return_all"
          get "active", to: "loans#get_active_loans"
        end
      end

      # Dashboard routes
      get "dashboard/summary" => "dashboard#get_summary"
      get "dashboard/loans_info" => "dashboard#get_loans_info"
      get "dashboard/equipment_info" => "dashboard#get_equipment_info"
      get "dashboard/equipment_per_sport" => "dashboard#get_equipment_per_sport"
      get "dashboard/loans_per_month" => "dashboard#get_loans_per_month"
      get "dashboard/loans_per_day" => "dashboard#get_loans_per_day"
      get "dashboard/loans_per_week" => "dashboard#get_loans_per_week"
      get "dashboard/loans_per_sport" => "dashboard#get_loans_per_sport"
    end
  end
end
