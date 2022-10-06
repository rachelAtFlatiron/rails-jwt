Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/me', to: "users#show"
  post '/signup', to: "users#create"
  post '/login', to: "sessions#create"
  post '/logout', to: "sessions#destroy"
end
