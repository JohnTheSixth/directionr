Rails.application.routes.draw do

  resources :users, except: [:index] do
  	resources :directions
  end
 
  resources :sessions

  resources :password_resets

  root 'sessions#new'

  get '/login' => 'sessions#new'

  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy'

end