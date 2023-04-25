Rails.application.routes.draw do
  resources :glasses
  # resources :users

  post '/login', to: "sessions#create"
  post '/signup', to: "users#create"
  delete '/logout', to: "sessions#destroy"
  get '/loggedin', to: "sessions#me"
  get '/google_user', to: 'sessions#google_user'

  get '/filter_by_brand/:brand', to: "glasses#get_by_brand"
  get '/filter_by_color/:color', to: "glasses#get_by_color"
  get '/filter_by_price/:min/:max', to: "glasses#get_by_price"
  get '/sunglasses', to: "glasses#sun_glasses"
  post '/virtualsearch', to: "glasses#virtual_search"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
