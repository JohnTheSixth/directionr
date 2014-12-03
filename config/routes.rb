Rails.application.routes.draw do

  resources :directions #, only: [:index, :show, :new]

  root to: 'directions#index'

end
