Rails.application.routes.draw do
  resources :projects do
    resources :examples
  end

  resources :results, only: :index
  resources :results, module: 'api', only: :create

  get '/results/compare', to: 'results#compare_view', as: 'result_compare'
  get '/api/results/compare_latest_of_tags', module: 'api', to: 'results#compare_latest_of_tags', as: 'api_results_compare_latest_of_tags'

  get '/token', to: 'token#show', as: 'token_show'
  post '/token', to: 'token#create', as: 'token_create'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  root to: 'home#index'
end
