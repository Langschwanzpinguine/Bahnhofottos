Rails.application.routes.draw do
  root to: "main#index"

  get "/map", to: "map#index", as: :map

  post "/api/overpass/stations", to: "overpass#stations"

  get "/proxy/map-tiles/thunderforest", to: "proxy#maptiles_thunderforest"
  get "/proxy/map-tiles/jawg", to: "proxy#maptiles_jawg"

  #Account system
  get '/users/sign_up', to: 'users#new', as: 'signup'
  post "/users/sign_up", to: 'users#create'
  get '/users/login', to: 'sessions#new', as: 'login'
  delete 'users/logout', to: 'sessions#destroy', as: 'logout'
  post '/users/login', to: 'sessions#create'

  get '/users/profile', to: 'users#profile', as: 'profile'
  get '/users/settings', to: 'users#settings', as: 'settings'
end
