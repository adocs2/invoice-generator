# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::GenerateTokenAndSendActivationEmail do
  let(:email) { 'user@example.com' }

  describe '#call!' do
    context 'when user does not exist' do
      it 'creates a new user with a token and sends activation email' do
        expect(User::Repository).to receive(:find_user_by_email).with(email).and_return(nil)
        expect(User::Repository).to receive(:create_user).with(email: email, authentication_token: anything, activation_token: anything).and_call_original
        expect(User::GenerateTokenAndSendActivationEmail).to receive(:new).and_call_original
        expect_any_instance_of(User::GenerateTokenAndSendActivationEmail).to receive(:send_activation_email).and_call_original

        result = described_class.call(email: email)

        expect(result).to be_success
        expect(result[:message]).to eq('Token gerado com sucesso. Verifique seu email para ativar.')
      end
    end

    context 'when user already exists' do
      it 'changes the user token and sends activation email' do
        existing_user = FactoryBot.create(:user)
        expect(User::Repository).to receive(:find_user_by_email).with(email).and_return(existing_user)
        expect(User::Repository).to receive(:change_user_token).with(existing_user, anything, anything).and_call_original
        expect(User::GenerateTokenAndSendActivationEmail).to receive(:new).and_call_original
        expect_any_instance_of(User::GenerateTokenAndSendActivationEmail).to receive(:send_activation_email).and_call_original

        result = described_class.call(email: email)

        expect(result).to be_success
        expect(result[:message]).to eq('Token gerado com sucesso. Verifique seu email para ativar.')
      end
    end
  end
end
