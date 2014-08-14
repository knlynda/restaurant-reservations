Rails.application.routes.draw do
  resources :tables do
    resources :reservations, only: [:create, :edit, :update, :destroy]
  end

  root to: 'tables#index'
end