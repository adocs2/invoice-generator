# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice::Record, type: :model do
  describe 'associations' do
    describe 'belong_to' do
      it { is_expected.to belong_to(:user) }
    end
  end

  describe 'validations' do
    subject { build(:invoice) }

    it { is_expected.to validate_uniqueness_of(:number).scoped_to(:user_id) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:company) }
    it { is_expected.to validate_presence_of(:billing_to) }
    it { is_expected.to validate_presence_of(:total_amount) }
  end

  describe 'to_param' do
    it 'returns the id as a string' do
      invoice = create(:invoice)
      expect(invoice.to_param).to eq(invoice.id.to_s)
    end
  end
end
