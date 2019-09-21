require 'sidekiq/web'

Rails.application.routes.draw do
  get 'search/find'
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    post '/insta_reg' => 'oauth_callbacks#insta_reg'
  end

  root to: 'questions#index'

  resources :users do
    resources :rewards, only: %i[index]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, shallow: true, concerns: :votable do
    resources :comments, only: %i[create]
    resources :answers, shallow: true, concerns: :votable do
      resources :comments, only: %i[create]
      patch :best, on: :member
    end
    resources :subscribers, shallow: true, only: %i[create destroy]
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'search', controller: :search, action: :find
end
