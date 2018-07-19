Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  namespace :api do
    root 'root#show'
    resources :planets, only: [:index, :show]
    resources :people, only: [:index, :show]
    resources :films, only: [:index, :show]
  end
end
