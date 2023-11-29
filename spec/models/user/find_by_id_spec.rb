# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::FindById do
  let(:user_id) { 1 }

  describe '#call!' do
    context 'when user is found' do
      let(:user) { instance_double('User') }

      before do
        allow(User::Repository).to receive(:find_user_by_id).with(user_id).and_return(user)
      end

      it 'returns a success result with the found user' do
        result = described_class.call(id: user_id)

        expect(result).to be_success
        expect(result[:user]).to eq(user)
      end
    end

    context 'when user is not found' do
      before do
        allow(User::Repository).to receive(:find_user_by_id).with(user_id).and_return(nil)
      end

      it 'returns a failure result with :user_not_found' do
        result = described_class.call(id: user_id)

        expect(result).to be_failure
        expect(result.type).to eq(:user_not_found)
      end
    end
  end
end
