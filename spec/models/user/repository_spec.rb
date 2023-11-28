# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Repository do
  let(:email) { 'user@example.com' }
  let(:authentication_token) { 'generated_token' }

  describe '#create_user' do
    it 'creates a user record' do
      user = described_class.create_user(email: email, authentication_token: authentication_token, activation_token: 'activation_token')

      expect(user).to be_persisted
      expect(user.email).to eq(email)
      expect(user.authentication_token).to eq(authentication_token)
      expect(user.activation_token).to eq('activation_token')
    end
  end

  describe '#find_user_by_id' do
    it 'finds a user by id' do
      user = FactoryBot.create(:user)

      found_user = described_class.find_user_by_id(user.id)

      expect(found_user).to eq(user)
    end

    it 'returns nil if id is invalid' do
      found_user = described_class.find_user_by_id('invalid_id')

      expect(found_user).to be_nil
    end
  end

  describe '#find_user_by_email' do
    it 'finds a user by email' do
      user = FactoryBot.create(:user)

      found_user = described_class.find_user_by_email(user.email)

      expect(found_user).to eq(user)
    end

    it 'returns nil if email is invalid' do
      found_user = described_class.find_user_by_email('invalid_email')

      expect(found_user).to be_nil
    end
  end

  describe '#find_user_by_authentication_token' do
    it 'finds a user by authentication_token' do
      user = FactoryBot.create(:user)

      found_user = described_class.find_user_by_authentication_token(user.authentication_token)

      expect(found_user).to eq(user)
    end

    it 'returns nil if authentication_token is invalid' do
      found_user = described_class.find_user_by_authentication_token('invalid_authentication_token')

      expect(found_user).to be_nil
    end
  end

  describe '#change_user_token' do
    it 'changes the user token' do
      user = FactoryBot.create(:user)

      result = described_class.change_user_token(user, authentication_token, 'new_activation_token')

      expect(result).to be_truthy
      expect(user.reload.authentication_token).to eq(authentication_token)
      expect(user.reload.activation_token).to eq('new_activation_token')
    end

    it 'returns false if the user is not persisted' do
      user = FactoryBot.build(:user)

      result = described_class.change_user_token(user, authentication_token, 'new_activation_token')

      expect(result).to be_falsey
    end
  end
end
