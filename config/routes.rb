Rails.application.routes.draw do
  resources :reservations
  root 'reservations#index'
end
