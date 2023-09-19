Rails.application.routes.draw do
  root to: "main#index"

  get "/map", to: "map#index", as: :map

  post "/api/overpass/stations", to: "overpass#stations"

  get "/proxy/map-tiles/thunderforest", to: "proxy#maptiles_thunderforest"
  get "/proxy/map-tiles/jawg", to: "proxy#maptiles_jawg"

  #Account system
  scope module: "account" do
    get '/users/sign_up', to: 'users#new', as: 'signup'
    post "/users/sign_up", to: 'users#create'

    get '/users/login', to: 'sessions#new', as: 'login'
    delete 'users/logout', to: 'sessions#destroy', as: 'logout'
    post '/users/login', to: 'sessions#create'

    get '/users/profile', to: 'users#profile', as: 'profile'
    delete '/users/profile', to: 'users#destroy', as: 'destroy_user'
    get '/users/settings', to: 'users#settings', as: 'settings'
    patch '/users/settings/avatar', to: 'users#upload_avatar', as: 'upload_avatar'

    get '/auth/password', to: 'auth#edit_password', as: 'edit_password'
    patch '/auth/password', to: 'auth#update_password'

    get '/auth/reset', to: 'password_resets#new'
    post '/auth/reset', to: 'password_resets#create'

    get '/auth/reset/edit', to: 'password_resets#edit'
    patch '/auth/reset/edit', to: 'password_resets#update'

    patch '/users/change_name', to: 'users#change_username'

    get '/friends', to: 'friends#index'
    post '/friends', to: 'friends#send_invitation'
    patch '/friends/accept_invitation', to: 'friends#accept_invitation', as: 'accept_invitation'
    delete '/friends/delete_invitation', to: 'friends#delete_invitation', as: 'delete_invitation'
    delete '/friends/unfriend', to: 'friends#unfriend', as: 'unfriend'
  end
end