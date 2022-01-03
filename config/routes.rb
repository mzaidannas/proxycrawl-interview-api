Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'api/v1/stream_controllers/products#index'

  scope module: :api, defaults: { format: :json } do
    scope module: :v1 do
      resources :products, except: :index
      get 'products', to: 'stream_controllers/products#index'
    end
  end
end
