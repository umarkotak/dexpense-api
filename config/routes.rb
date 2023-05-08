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
  get '/api/v1/transactions/download', to: 'transactions#download'
  get '/api/v1/transactions/summary', to: 'transactions#summary'
  patch '/api/v1/transactions/:id', to: 'transactions#edit'
  delete '/api/v1/transactions/:id', to: 'transactions#delete'
  get '/api/v1/transactions', to: 'transactions#index'
  get '/api/v1/transactions/daily', to: 'transactions#index_daily'
  get '/api/v1/transactions/monthly', to: 'transactions#index_monthly'
  get '/api/v1/transactions/:id', to: 'transactions#show'
  post '/api/v1/transactions/transfer', to: 'transactions#transfer'
  post '/api/v1/transactions/adjust', to: 'transactions#adjust'

  get '/api/v1/statistics/transactions/daily', to: 'statistics#transactions_daily'
  get '/api/v1/statistics/transactions/per_category', to: 'statistics#transactions_per_category'
  get '/api/v1/statistics/transactions/dashboard', to: 'statistics#transactions_dashboard'
  get '/api/v1/statistics/whealth/daily', to: 'statistics#whealth_daily'

  get '/api/v1/monthly_budgets', to: 'monthly_budgets#index'
  get '/api/v1/monthly_budgets/current', to: 'monthly_budgets#index_current'
  post '/api/v1/monthly_budgets', to: 'monthly_budgets#create'
  get '/api/v1/monthly_budgets/:category', to: 'monthly_budgets#show'
  patch '/api/v1/monthly_budgets/:category', to: 'monthly_budgets#edit'
  delete '/api/v1/monthly_budgets/:category', to: 'monthly_budgets#delete'

  get '/api/v1/categories/index/static', to: 'categories#index_static'

  get '/api/v1/hfgolds/gold/prices', to: 'hfgolds#gold_prices'

  get '/api/v1/wealth_assets/categories', to: 'wealth_assets#categories'
  post '/api/v1/wealth_assets', to: 'wealth_assets#create'
  get '/api/v1/wealth_assets', to: 'wealth_assets#index'
  get '/api/v1/wealth_assets/dashboard', to: 'wealth_assets#dashboard'
  get '/api/v1/wealth_assets/groupped', to: 'wealth_assets#groupped'
end
