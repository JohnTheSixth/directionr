Rails.application.routes.draw do

  resources :users, except: [:index] do
  	resources :directions
  end

  get '/directions/all' => 'directions#all'
  get '/directions/:id/view' => 'directions#view'

  resources :sessions

  resources :password_resets

  root 'directions#all'

  get '/login' => 'sessions#new'

  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy'

end