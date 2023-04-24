Rails.application.routes.draw do
  #resources :sales
  resources :glasses
  resources :users

  post '/login', to: "sessions#create"
  post '/signup', to: "users#create"
  delete '/logout', to: "sessions#destroy"
  get '/loggedin', to: "sessions#me"

  post '/admin/login', to: "adminsessions#create"
  get '/admin/me', to: "adminsessions#current_admin"
  get '/admin/logout', to: "adminsessions#logout"
  

  get '/filter_by_brand/:brand', to: "glasses#get_by_brand"
  get '/filter_by_color/:color', to: "glasses#get_by_color"
  get '/filter_by_price/:min/:max', to: "glasses#get_by_price"
  get '/sunglasses', to: "glasses#sun_glasses"
  post '/virtualsearch', to: "glasses#virtual_search"

  # Sales
  get '/brandsales', to: "sales#by_brand"
  get '/colorsales', to: "sales#by_color"
  get '/payments', to: "sales#by_mode_of_payment"

  # Products
  post '/admins/newproduct', to: "admins#new_product"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
