Rails.application.routes.draw do
  resources :volunteer_assignments
  resources :events do
    collection do
      get :available
    end
  end
  resources :admins, only: []  # No standard routes - we use custom ones below
  resources :volunteers

  # Custom admin routes - must be before resources to avoid conflicts
  get "admin", to: "admins#index", as: :admin
  get "admin/profile", to: "admins#show", defaults: { id: 1 }
  get "admin/profile/edit", to: "admins#edit", defaults: { id: 1 }
  patch "admin/profile", to: "admins#update"
  put "admin/profile", to: "admins#update"

  # Analytics route
  get "analytics", to: "analytics#index", as: :analytics

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/") — show volunteer login first
  root "sessions#new"
end
