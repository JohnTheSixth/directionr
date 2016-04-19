Rails.application.routes.draw do

  resources :users, except: [:index] do
  	resources :directions
  end

  resources :password_resets

  root to: 'sessions#new'

  get '/login' => 'sessions#new'

  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy'

end