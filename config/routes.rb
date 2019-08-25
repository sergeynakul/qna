Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :users do
    resources :rewards, only: %i[index]
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, shallow: true, concerns: :votable do
    resources :comments, only: %i[create]
    resources :answers, concerns: :votable do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
