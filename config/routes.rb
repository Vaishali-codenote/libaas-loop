Rails.application.routes.draw do
  devise_for :users

  get "/admin/login", to: "admin/sessions#new", as: :new_admin_login
  post "/admin/login", to: "admin/sessions#create", as: :admin_login
  delete "/admin/logout", to: "admin/sessions#destroy", as: :admin_logout

  root "home#index"

  resources :listings do
    resources :rentals, only: [:create]
  end

  authenticated :user do
    resources :rentals, only: [:update, :index, :show] do
      member do
        post :approve
        post :reject
        post :mark_returned
      end
    end

    get "my_listings", to: "my_listings#index"
    get "my_rentals", to: "my_rentals#index"
  end

  namespace :admin do
    root "dashboard#index"
    get "dashboard", to: "dashboard#index"
    get "reports", to: "reports#index"

    resources :users do
      member do
        patch :block
        patch :unblock
        patch :promote
      end
    end

    resources :listings do
      member do
        patch :approve
        patch :reject
      end
    end

    resources :rentals do
      member do
        patch :cancel
        patch :force_complete
        patch :issue_refund
      end
    end

    resources :categories do
      member do
        patch :toggle_status
      end
    end
  end
end
