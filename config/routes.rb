Rails.application.routes.draw do
 
  resources :user_stocks, only: [:create]
  devise_for :users
  root "welcome#index"
  get "/my_portfolio", to: "users#my_portfolio"
  get "/index", to: "welcome#index"
  get "search_stock", to: "stocks#search"
end
