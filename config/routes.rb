Rails.application.routes.draw do
  get 'setup', to: 'setup#new', as: 'setup'
  post 'configure', to: 'setup#create', as: 'configure'

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :setup, only: [:new, :create]
  get 'chat/index'
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'chat#index'
end
