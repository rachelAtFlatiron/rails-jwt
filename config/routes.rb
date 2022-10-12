Rails.application.routes.draw do
  post '/signup', to: 'users#create'
  post '/me', to: 'application#login'
end
