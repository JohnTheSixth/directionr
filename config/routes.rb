Rails.application.routes.draw do

  get 'password_resets/new'

  resources :users, only: [:create, :new, :edit, :show, :update, :destroy] do

    resources :directions
  
  end

  root to: 'sessions#new'

  get '/login' => 'sessions#new'

  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy'

  resources :password_resets

end
