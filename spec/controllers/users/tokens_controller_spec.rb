# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::TokensController, type: :controller do
  describe 'GET #sign_in' do
    it 'renders the sign_in template' do
      get :sign_in
      expect(response).to render_template('users/sign_in')
    end
  end

  describe 'POST #generate_token_and_send_activation' do
    context 'when successful' do
      it 'sets a success flash message and redirects to sign_in' do
        post :generate_token_and_send_activation, params: { email: 'user@example.com' }
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(users_sign_in_path)
      end
    end

    context 'when unsuccessful' do
      it 'sets an error flash message and redirects to sign_in' do
        allow(User::GenerateTokenAndSendActivationEmail).to receive(:call).and_return(Micro::Case::Result.new(:failure))
        post :generate_token_and_send_activation, params: { email: 'invalid_email' }
        expect(flash[:error]).to be_present
        expect(response).to redirect_to(users_sign_in_path)
      end
    end
  end

  describe 'POST #activate_user' do
    context 'when successful' do
      it 'sets a success flash message and redirects to sign_in' do
        user = FactoryBot.create(:user, email: 'user@example.com', activation_token: 'abc123')
        post :activate_user, params: { email: user.email, activation_token: user.activation_token }
        expect(flash[:success]).to be_present
        expect(flash[:success]).to eq('Token ativado com sucesso.')
        expect(response).to redirect_to(users_sign_in_path)
      end
    end

    context 'when unsuccessful' do
      it 'sets an error flash message and redirects to sign_in' do
        allow(User::ActivateToken).to receive(:call).and_return(Micro::Case::Result.new(:failure))
        post :activate_user, params: { email: 'user@example.com', activation_token: 'invalid_token' }
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('Erro ao ativar token.')
        expect(response).to redirect_to(users_sign_in_path)
      end
    end
  end

  describe 'POST #login_with_token' do
    context 'when successful' do
      it 'sets a success flash message and redirects to root_path' do
        user = FactoryBot.create(:user)
        post :login_with_token, params: { token: user.authentication_token }
        expect(flash[:success]).to be_present
        expect(flash[:success]).to eq('Usuário logado com sucesso.')
        expect(response).to redirect_to(users_sign_in_path)
      end
    end

    context 'when unsuccessful' do
      it 'sets an error flash message and redirects to root_path' do
        allow(User::LoginWithToken).to receive(:call).and_return(Micro::Case::Result.new(:failure))
        post :login_with_token, params: { token: 'invalid_token' }
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('Erro ao logar com token.')
        expect(response).to redirect_to(users_sign_in_path)
      end
    end
  end
end
