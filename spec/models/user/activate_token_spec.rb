# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::ActivateToken do
  let(:email) { 'user@example.com' }
  let(:activation_token) { 'valid_token' }
  let(:invalid_token) { 'invalid_token' }
  let(:user) { FactoryBot.create(:user, email: email, activation_token: activation_token) }

  describe '#call!' do
    context 'when user exists and activation token is valid' do
      it 'activates the user and sends a welcome email' do
        expect(User::Repository).to receive(:find_user_by_email).with(email).and_return(user)
        expect(User::Repository).to receive(:activate_user).with(user, activation_token)

        result = described_class.call(email: email, activation_token: activation_token)

        expect(result).to be_success
      end
    end

    context 'when user does not exist' do
      it 'returns a failure result' do
        expect(User::Repository).to receive(:find_user_by_email).with(email).and_return(nil)

        result = described_class.call(email: email, activation_token: activation_token)

        expect(result).to be_failure
        expect(result.type).to eq(:user_not_found)
      end
    end

    context 'when activation token is invalid' do
      it 'returns a failure result' do
        expect(User::Repository).to receive(:find_user_by_email).with(email).and_return(user)
        result = described_class.call(email: email, activation_token: invalid_token)

        expect(result).to be_failure
        expect(result.type).to eq(:activation_token_invalid)
      end
    end
  end
end
