Rails.application.routes.draw do
  namespace :api, path: '/', constraints: { subdomain: 'api' } do
    namespace :v1 do
      resources :pessoas_fisicas, except: :destroy
      resources :pessoas_juridicas, except: :destroy
      resources :contas
      resources :transacoes, only: [:index, :show, :create]
    end
  end
end
