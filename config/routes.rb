Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post '/auth/login', to: 'authentications#login'
      post 'transfer', to: 'users#transfer'
      post 'create', to: 'users#create'
      get 'balance', to: 'accounts#balance'
    end
  end
end
