Rails.application.routes.draw do
  root to: "main#index"

  get "/map", to: "map#index", as: :map

  post "/api/overpass/stations", to: "overpass#stations"

  get "/proxy/map-tiles/thunderforest", to: "proxy#maptiles_thunderforest"
  get "/proxy/map-tiles/jawg", to: "proxy#maptiles_jawg"

  #Account system
  get '/users/sign_up', to: 'users#new', as: 'signup'
  post "/users/sign_up", to: 'users#create'
  # get 'login', to: 'sessions#new', as: 'login'
  # get 'logout', to: 'sessions#destroy', as: 'logout'
end
