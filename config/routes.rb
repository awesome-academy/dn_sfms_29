Rails.application.routes.draw do
  root "static_pages#home"
  namespace :admin do
    root "pages#home"
    resources :subpitch_types
    resources :pitches do
      resources :subpitches, except: :index, controller: "pitches/subpitches"
      get "/revenue", to: "pitches/revenues#index", on: :collection
      get "/revenue", to: "pitches/revenues#show", on: :member
    end
    resources :ratings, only: %i(index destroy), controller: "subpitches/ratings"
    resources :users, controller: "/users" do
      resources :roles, only: :create, controller: "users/roles"
    end
  end
  resources :bookings, only: :index
  post "/login", to: "sessions#create"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: [:get, :post]
  get "/blog", to: "static_pages#blog"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  devise_for :users, controllers: {registrations: "registrations"}
  resources :users, only: %i(index show destroy)
  resources :pitches, only: :index do
    resources :subpitches, only: %i(index show) do
      resources :likes, only: %i(create destroy), controller: "subpitches/likes"
    end
  end
end
