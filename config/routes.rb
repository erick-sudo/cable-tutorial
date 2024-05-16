Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :conversations, only: [:index, :create]
  resources :messages, only: [:create]
  mount ActionCable.server => '/cable'
end
