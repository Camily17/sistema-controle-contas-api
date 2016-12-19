  Rails.application.routes.draw do
    namespace :api, path: '/', constraints: { subdomain: 'api' } do
      namespace :v1 do
        resources :pessoas_fisicas
      end
    end
  end
