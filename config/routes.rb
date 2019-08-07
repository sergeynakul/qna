Rails.application.routes.draw do
  get 'attachments/destroy'
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true do
    resources :answers do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
end
