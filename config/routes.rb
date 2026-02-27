Rails.application.routes.draw do
  devise_for :users

  # Public routes
  root "home#index"
  resources :listings

  # User routes
  authenticated :user do
    resources :rentals, only: [:create, :update, :index, :show] do
      member do
        post :approve
        post :reject
        post :mark_returned
      end
    end

    get "my_listings", to: "my_listings#index"
    get "my_rentals", to: "my_rentals#index"
  end

  # Admin namespace
  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users, only: [:index, :show, :destroy] do
      member do
        patch :toggle_status
      end
    end
    resources :listings, only: [:index, :show, :destroy]
    resources :rentals, only: [:index, :show, :update]
  end
end
