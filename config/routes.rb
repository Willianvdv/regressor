Rails.application.routes.draw do
  resources :projects do
    resources :examples
  end

  resources :results, only: [:create, :index]
  get '/results/compare', to: 'results#compare_view', as: 'result_compare'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  root to: 'home#index'
end
