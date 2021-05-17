Rails.application.routes.draw do
  root 'ping#index'

  post '/accounts/register', to: 'accounts#register'
  post '/accounts/login', to: 'accounts#login'
  get '/accounts/profile', to: 'accounts#profile'

  post '/groups/:id/invite', to: 'groups#invite'

  post '/transactions', to: 'transactions#create'
  get '/transactions', to: 'transactions#index'
end
