Rails.application.routes.draw do
 
  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  root "welcome#index"

  get "/my_portfolio", to: "users#my_portfolio"
  get "/index", to: "welcome#index"
  get "search_stock", to: "stocks#search"
  get "/my_friends", to: "users#show_friends"
  get "search_friend", to: "users#search"
  resources :friendships, only: [:create, :destroy]
 end
