# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Record, type: :model do
  describe 'associations' do
    describe 'has_many' do
      it { is_expected.to have_many(:invoices) }
    end
  end

  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:authentication_token) }
    it { is_expected.to validate_uniqueness_of(:authentication_token) }
  end
end
