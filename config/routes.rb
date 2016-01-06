Rails.application.routes.draw do
  resources :projects do
    resources :examples
  end
  post '/projects/:id/add_user', to: 'projects#add_user'

  resources :results, only: :index
  get '/results/compare', to: 'results#compare_view', as: 'result_compare'

  scope 'api', module: 'api' do
    resources :results, only: :create
    get 'results/compare_latest_of_tags', to: 'results#compare_latest_of_tags'
  end

  get '/token', to: 'token#show', as: 'token_show'
  post '/token', to: 'token#create', as: 'token_create'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  root to: 'home#index'
end
