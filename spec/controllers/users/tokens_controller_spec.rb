# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::TokensController, type: :controller do
  describe 'GET #generate_token' do
    it 'renders the generate_token template' do
      get :generate_token
      expect(response).to render_template('users/tokens/generate_token')
    end
  end

  describe 'POST #generate_token_and_send_activation' do
    context 'when successful' do
      it 'sets a success flash message and redirects to sign_in' do
        post :generate_token_and_send_activation, params: { email: 'user@example.com' }
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when unsuccessful' do
      it 'sets an error flash message and redirects to sign_in' do
        allow(User::GenerateTokenAndSendActivationEmail).to receive(:call).and_return(Micro::Case::Result.new(:failure))
        post :generate_token_and_send_activation, params: { email: 'invalid_email' }
        expect(flash[:error]).to be_present
        expect(response).to redirect_to(root_path)
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
        expect(response).to redirect_to(invoices_path)
      end
    end

    context 'when unsuccessful' do
      it 'sets an error flash message and redirects to sign_in' do
        allow(User::ActivateToken).to receive(:call).and_return(Micro::Case::Result.new(:failure))
        post :activate_user, params: { email: 'user@example.com', activation_token: 'invalid_token' }
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq('Erro ao ativar token.')
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
