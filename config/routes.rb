Rails.application.routes.draw do
  root 'ping#index'

  post '/api/v1/accounts/register', to: 'accounts#register'
  post '/api/v1/accounts/login', to: 'accounts#login'
  get '/api/v1/accounts/profile', to: 'accounts#profile'

  post '/api/v1/groups/:id/invite', to: 'groups#invite'

  post '/api/v1/transactions', to: 'transactions#create'
  get '/api/v1/transactions', to: 'transactions#index'
end
