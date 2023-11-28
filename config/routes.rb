# config/routes.rb
Rails.application.routes.draw do
  namespace :users do
    get '/sign_in', to: 'tokens#sign_in'
    post '/generate_and_send_activation', to: 'tokens#generate_token_and_send_activation'
    get '/activate_user', to: 'tokens#activate_user'
    post '/login_with_token', to: 'tokens#login_with_token'
  end
end
