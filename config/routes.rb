Rails.application.routes.draw do

  resources :users, except: [:index] do #Add param: :username, after :users to sub in username
  	resources :directions
  end
  get '/users/:id/confirm' => 'users#confirm'
  get '/users/:id/deny' => 'users#deny'

  get '/directions/all' => 'directions#all'
  get '/directions/:id/view' => 'directions#view'

  resources :sessions

  resources :password_resets

  root 'directions#all'

  get '/login' => 'sessions#new'

  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy'

end