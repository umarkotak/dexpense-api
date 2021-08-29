Rails.application.routes.draw do
  root 'ping#index'

  post '/api/v1/accounts/register', to: 'accounts#register'
  post '/api/v1/accounts/login', to: 'accounts#login'
  get '/api/v1/accounts/profile', to: 'accounts#profile'

  post '/api/v1/groups', to: 'groups#create'
  post '/api/v1/groups/:group_id/invite', to: 'groups#invite'
  get '/api/v1/groups/:group_id', to: 'groups#show'
  get '/api/v1/groups', to: 'groups#index'
  patch '/api/v1/groups/:group_id', to: 'groups#edit'

  post '/api/v1/group_wallets', to: 'group_wallets#create'
  patch '/api/v1/group_wallets/:id', to: 'group_wallets#edit'
  delete '/api/v1/group_wallets/:id', to: 'group_wallets#delete'

  post '/api/v1/transactions', to: 'transactions#create'
  patch '/api/v1/transactions/:id', to: 'transactions#edit'
  delete '/api/v1/transactions/:id', to: 'transactions#delete'
  get '/api/v1/transactions', to: 'transactions#index'

  # TODO LIST:
  # group delete
  # group remove member
end
