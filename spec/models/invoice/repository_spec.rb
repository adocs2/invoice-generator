# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice::Repository do
  let(:user) { create(:user) }

  describe '#create_invoice' do
    it 'creates a new invoice' do
      invoice_params = { number: 123, date: '2023-12-01', company: 'Test Company', billing_to: 'Test Billing', total_amount: 100, user_id: user.id }

      result = described_class.create_invoice(invoice_params)

      expect(result).to be_an_instance_of(::Invoice::Record)
      expect(result.number).to eq(123)
    end

    it 'returns false if the invoice is not saved' do
      allow_any_instance_of(::Invoice::Record).to receive(:save).and_return(false)

      invoice_params = { number: 123, date: '2023-12-01', company: 'Test Company', billing_to: 'Test Billing', total_amount: 100, user_id: user.id }

      result = described_class.create_invoice(invoice_params)

      expect(result).to be false
    end
  end

  describe '#find_invoice_by_id' do
    it 'finds an invoice by ID' do
      invoice = create(:invoice)

      result = described_class.find_invoice_by_id(invoice.id)

      expect(result).to eq(invoice)
    end

    it 'returns nil if ID is nil' do
      result = described_class.find_invoice_by_id(nil)

      expect(result).to be_nil
    end
  end

  describe '#find_invoices_by_user_id' do
    it 'finds invoices by user ID and optional date and number' do
      user_invoices = create_list(:invoice, 3, user: user)

      result = described_class.find_invoices_by_user_id(user.id)

      expect(result).to contain_exactly(*user_invoices)
    end

    it 'filters invoices by date if provided' do
      user_invoices = create_list(:invoice, 2, user: user, date: '2023-12-01')
      create(:invoice, user: user, date: '2023-12-02')

      result = described_class.find_invoices_by_user_id(user.id, date: '2023-12-01')

      expect(result).to contain_exactly(*user_invoices)
    end

    it 'filters invoices by number if provided' do
      user_invoices = create(:invoice, user: user, number: 456)

      result = described_class.find_invoices_by_user_id(user.id, number: 456)

      expect(result).to contain_exactly(*user_invoices)
    end
  end
end
