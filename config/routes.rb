Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: "main#index"

  get "/map", to: "map#index", as: :map

  post "/api/overpass/stations", to: "overpass#stations"
  # Defines the root path route ("/")
  # root "articles#index"
end
