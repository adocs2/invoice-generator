# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users/sessions#new'

  namespace :users do
    post 'login', to: 'sessions#create', as: :login
    delete 'logout', to: 'sessions#destroy', as: :logout

    get 'generate_token', to: 'tokens#generate_token', as: :generate_token
    post 'generate_token_and_send_activation', to: 'tokens#generate_token_and_send_activation', as: :generate_token_and_send_activation
    get 'activate_user', to: 'tokens#activate_user', as: :activate_user
  end
end
