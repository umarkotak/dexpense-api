Rails.application.routes.draw do
  root 'ping#index'

  post '/api/v1/accounts/register', to: 'accounts#register'
  post '/api/v1/accounts/login', to: 'accounts#login'
  get '/api/v1/accounts/profile', to: 'accounts#profile'

  post '/api/v1/groups', to: 'groups#create'
  post '/api/v1/groups/:group_id/invite', to: 'groups#invite_member'
  post '/api/v1/groups/:group_id/remove', to: 'groups#remove_member'
  get '/api/v1/groups/:group_id', to: 'groups#show'
  get '/api/v1/groups', to: 'groups#index'
  patch '/api/v1/groups/:group_id', to: 'groups#edit'
  delete '/api/v1/groups/:group_id', to: 'groups#delete'

  post '/api/v1/group_wallets', to: 'group_wallets#create'
  patch '/api/v1/group_wallets/:id', to: 'group_wallets#edit'
  delete '/api/v1/group_wallets/:id', to: 'group_wallets#delete'

  post '/api/v1/transactions', to: 'transactions#create'
  patch '/api/v1/transactions/:id', to: 'transactions#edit'
  delete '/api/v1/transactions/:id', to: 'transactions#delete'
  get '/api/v1/transactions', to: 'transactions#index'
  get '/api/v1/transactions/:id', to: 'transactions#show'
  post '/api/v1/transactions/transfer', to: 'transactions#transfer'
  post '/api/v1/transactions/adjust', to: 'transactions#adjust'

  get '/api/v1/statistics/transactions/daily', to: 'statistics#transactions_daily'

  # TODO LIST:
  # dashboard API
  # statistics API
end
