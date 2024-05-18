Rails.application.routes.draw do
  root "application#welcome"

  get "test-job", to: 'users#job_test'

  post 'login', to: 'login#login'
  get 'current-user', to: 'users#logged_in_user'
  resources :conversations, only: [:index, :create]
  resources :messages, only: [:create]
  mount ActionCable.server => '/cable'
end
