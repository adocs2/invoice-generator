# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::LoginWithToken do
  let(:authentication_token) { 'valid_token' }
  let(:repository) { instance_double(User::Repository) }

  describe '#call!' do
    context 'when user is found and activated' do
      let(:user) { instance_double(User::Record, activated?: true) }

      it 'logs in the user successfully' do
        allow(repository).to receive(:find_user_by_authentication_token).with(authentication_token).and_return(user)

        result = described_class.call(authentication_token: authentication_token, repository: repository)

        expect(result).to be_success
        expect(result[:user]).to eq(user)
      end
    end

    context 'when user is not found' do
      it 'returns a failure result' do
        allow(repository).to receive(:find_user_by_authentication_token).with(authentication_token).and_return(nil)

        result = described_class.call(authentication_token: authentication_token, repository: repository)

        expect(result).to be_failure
        expect(result.type).to eq(:user_not_found)
      end
    end

    context 'when user is found but not activated' do
      let(:user) { instance_double(User::Record, activated?: false) }

      it 'returns a failure result' do
        allow(repository).to receive(:find_user_by_authentication_token).with(authentication_token).and_return(user)

        result = described_class.call(authentication_token: authentication_token, repository: repository)

        expect(result).to be_failure
        expect(result.type).to eq(:invalid_token)
      end
    end
  end
end
