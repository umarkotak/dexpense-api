Rails.application.routes.draw do
  root 'ping#index'

  post '/api/v1/accounts/register', to: 'accounts#register'
  post '/api/v1/accounts/login', to: 'accounts#login'
  get '/api/v1/accounts/profile', to: 'accounts#profile'

  post '/api/v1/groups', to: 'groups#create'
  post '/api/v1/groups/:group_id/invite', to: 'groups#invite'
  get '/api/v1/groups/:group_id', to: 'groups#show'

  post '/api/v1/group_wallets', to: 'group_wallets#create'

  post '/api/v1/transactions', to: 'transactions#create'
  get '/api/v1/transactions', to: 'transactions#index'

  # TODO LIST:
  # transaction edit
  # transaction delete
  # group edit
  # group delete
  # group wallet edit
  # group wallet delete
end
