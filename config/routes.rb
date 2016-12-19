  Rails.application.routes.draw do
    namespace :api, path: '/', constraints: { subdomain: 'api' } do
      namespace :v1 do
        resources :pessoas_fisicas
        resources :pessoas_juridicas
      end
    end
  end
