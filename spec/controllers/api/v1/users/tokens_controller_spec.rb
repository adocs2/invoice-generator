# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::TokensController, type: :controller do
  describe 'POST #generate_token_and_send_activation' do
    context 'when token generation and email sending is successful' do
      let(:user) { create(:user) }

      it 'returns a success response with the generated message' do
        allow(User::GenerateTokenAndSendActivationEmail).to receive(:call).with(email: user.email).and_return(Micro::Case::Result::Success.new( data: { message: 'Token gerado com sucesso. Verifique seu email para ativar.' } ))

        post :generate_token_and_send_activation, params: { email: user.email }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Token gerado com sucesso. Verifique seu email para ativar.' })
      end
    end

    context 'when token generation or email sending fails' do
      let(:email) { 'test@example.com' }

      it 'returns an error response with the error message' do
        allow(User::GenerateTokenAndSendActivationEmail).to receive(:call).with(email: email).and_return(Micro::Case::Result::Failure.new(type: :failure ))

        post :generate_token_and_send_activation, params: { email: email }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Erro ao gerar token e enviar email.' })
      end
    end
  end

  describe 'POST #activate_user' do
    context 'when user activation is successful' do
      let(:user) { create(:user, activation_token: 'qweoip', activated: false) }

      it 'returns a success response with the authentication token' do
        allow(User::ActivateToken).to receive(:call).with(email: user.email, activation_token: user.activation_token).and_return(Micro::Case::Result::Success.new(type: :user, data: { user: user } ))

        post :activate_user, params: { email: user.email, activation_token: user.activation_token }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq({ 'data' => { 'authentication_token' => user.authentication_token }, 'message' => 'Token ativado com sucesso.' })
      end
    end

    context 'when user activation fails' do
      let(:user) { create(:user) }
      let(:activation_token) { 'abc123' }

      it 'returns an error response with the error message' do
        allow(User::ActivateToken).to receive(:call).with(email: user.email, activation_token: activation_token).and_return(Micro::Case::Result::Failure.new(type: :activation_token_invalid))

        post :activate_user, params: { email: user.email, activation_token: activation_token }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Erro ao ativar token.' })
      end
    end
  end
end
