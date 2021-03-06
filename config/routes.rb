Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount ActionCable.server => "/cable"

  root to: "homes#show"
  get "/search", to: "homes#search", as: :search_posts

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, only: [:create] do
    resource :password, controller: "clearance/passwords", only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  resources :profiles, only: [:show, :edit, :update]
  resources :posts, only: [:index, :show, :new, :edit, :update, :create] do
    resources :join_requests, only: [:create, :update, :destroy]
  end
  resources :interested_posts, only: [:index]
  resources :notifications, only: [:index] do
    patch "mark_as_read", on: :collection
  end
end
