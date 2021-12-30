Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'products#index'

  resources :products, except: :index
  get 'products', to: 'live_controllers/products#index'
end
