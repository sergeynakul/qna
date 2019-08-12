Rails.application.routes.draw do
  get 'rewards/index'
  get 'attachments/destroy'
  devise_for :users
  root to: 'questions#index'

  resources :users do
    resources :rewards, only: %i[index]
  end

  resources :questions, shallow: true do
    resources :answers do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
end
