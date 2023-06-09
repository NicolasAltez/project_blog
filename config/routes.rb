Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  
  resources :posts do
    resources :comments
  end
  
  root to: 'posts#index'
end
