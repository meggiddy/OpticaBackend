Rails.application.routes.draw do
  resources :glasses
  # resources :users

  post '/login', to: "sessions#create"
  post '/signup', to: "users#create"
  delete '/logout', to: "sessions#destroy"
  get '/me', to: "sessions#me"

  get '/filter_by_brand/:brand', to: "glasses#get_by_brand"
  get '/filter_by_color/:color', to: "glasses#get_by_color"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
