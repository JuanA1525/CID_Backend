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
          post ":id/rate", to: "loans#add_rating_to_loan"
        end
      end

      # Message routes
      resources :messages do
        collection do
          get "user_messages/:user_id", to: "messages#get_messages_by_user"
        end
      end

      # pqrfs routes
      resources :pqrsfs do
        collection do
          get "user_pqrsfs/:user_id", to: "pqrsfs#get_pqrsf_by_user"
          get "pending_pqrsfs", to: "pqrsfs#get_pending_pqrsf"
          get "pqrsfs_per_type/:pqrsf_type", to: "pqrsfs#get_pqrsf_per_type"
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
      get "dashboard/average_rating_per_sport" => "dashboard#get_average_rating_per_sport"
      get "dashboard/average_rating_per_equipment" => "dashboard#get_average_rating_per_equipment"
      get "dashboard/average_rating_for_loans" => "dashboard#get_average_rating_for_loans"
      get "dashboard/top_five_users_with_more_loans" => "dashboard#get_top_five_users_with_more_loans"
      get "dashboard/top_five_users_with_more_ratings" => "dashboard#get_top_five_users_with_more_ratings"
      get "dashboard/users_per_status" => "dashboard#get_users_per_status"
      get "dashboard/users_per_role" => "dashboard#get_users_per_role"
      get "dashboard/users_per_occupation" => "dashboard#get_users_per_occupation"
      get "dashboard/equipment_per_type" => "dashboard#get_equipment_per_type"
      get "dashboard/equipment_per_condition" => "dashboard#get_equipment_per_condition"
      get "dashboard/loans_per_status" => "dashboard#get_loans_per_status"
      get "dashboard/loans_per_rating" => "dashboard#get_loans_per_rating"
      get "dashboard/pqrsf_per_type" => "dashboard#get_pqrsf_per_type"
      get "dashboard/pqrsf_per_pending" => "dashboard#get_pqrsf_per_pending"
      get "dashboard/pqrsf_per_week" => "dashboard#get_pqrsf_per_week"
      get "dashboard/pqrsf_per_day" => "dashboard#get_pqrsf_per_day"
      get "dashboard/pqrsf_per_month" => "dashboard#get_pqrsf_per_month"
    end
  end
end
