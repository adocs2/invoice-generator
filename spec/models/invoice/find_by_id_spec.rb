# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice::FindById do
  let(:invoice_id) { 1 }

  describe '#call!' do
    context 'when Invoice is found' do
      let(:invoice) { instance_double('Invoice') }

      before do
        allow(Invoice::Repository).to receive(:find_invoice_by_id).with(invoice_id).and_return(invoice)
      end

      it 'returns a success result with the found invoice' do
        result = described_class.call(invoice_id: invoice_id)

        expect(result).to be_success
        expect(result[:invoice]).to eq(invoice)
      end
    end

    context 'when invoice is not found' do
      before do
        allow(Invoice::Repository).to receive(:find_invoice_by_id).with(invoice_id).and_return(nil)
      end

      it 'returns a failure result with :invoice_not_found' do
        result = described_class.call(invoice_id: invoice_id)

        expect(result).to be_failure
        expect(result.type).to eq(:invoice_not_found)
      end
    end
  end
end
