Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post '/auth/login', to: 'authentications#login'
      post 'users/transfer', to: 'users#transfer'
      post 'users/create', to: 'users#create'
      get 'accouts/balance', to: 'accounts#balance'
    end
  end
end
