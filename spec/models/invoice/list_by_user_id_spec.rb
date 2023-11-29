# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice::ListByUserId do
  let(:user) { create(:user) }
  let(:filter_options) { {} }

  describe '#call!' do
    context 'when the user has invoices' do
      let!(:invoices) { create_list(:invoice, 3, user: user) }

      it 'returns a success result with the invoices' do
        allow(Invoice::Repository).to receive(:find_invoices_by_user_id).with(user.id, filter_options).and_return(invoices)

        result = described_class.call(user_id: user.id, filter_options: filter_options)

        expect(result).to be_success
        expect(result.type).to eq(:invoices_found)
        expect(result.data[:invoices]).to match_array(invoices)
      end
    end

    context 'when the user has no invoices' do
      it 'returns a success result with an empty array' do
        allow(Invoice::Repository).to receive(:find_invoices_by_user_id).with(user.id, filter_options).and_return([])

        result = described_class.call(user_id: user.id, filter_options: filter_options)

        expect(result).to be_success
        expect(result.type).to eq(:invoices_found)
        expect(result.data[:invoices]).to be_empty
      end
    end

    context 'when the filter options are present' do
      let(:filter_options) { { number: 123, date: Date.today } }

      it 'calls the repository with the cleaned filter options' do
        expect(Invoice::Repository).to receive(:find_invoices_by_user_id).with(user.id, filter_options)

        described_class.call(user_id: user.id, filter_options: filter_options)
      end
    end

    context 'when the filter options are blank' do
      let(:filter_options) { { number: '', date: '' } }

      it 'calls the repository with an empty hash' do
        expect(Invoice::Repository).to receive(:find_invoices_by_user_id).with(user.id, {})

        described_class.call(user_id: user.id, filter_options: filter_options)
      end
    end
  end
end
