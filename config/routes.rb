Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      post '/auth/login', to: 'authentications#login'
    end
  end
end
