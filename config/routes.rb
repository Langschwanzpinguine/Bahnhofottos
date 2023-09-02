Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "main#index"

  get "/map", to: "map#index", as: :map

  post "/api/overpass/stations", to: "overpass#stations"

  get "/proxy/map-tiles/thunderforest", to: "proxy#maptiles_thunderforest"
  get "/proxy/map-tiles/jawg", to: "proxy#maptiles_jawg"
  # Defines the root path route ("/")
  # root "articles#index"
end
