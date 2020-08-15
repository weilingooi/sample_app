Rails.application.routes.draw do
  root "static_pages#home"
  
  get "static_pages/home"
  get "static_pages/help"
  resources :users, only: %i(new create show)
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
end
