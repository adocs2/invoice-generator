# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Invoices::InvoicesController, type: :controller do
  let(:user) { create(:user, authentication_token: 'valid_token') }

  before do
    request.headers['Authorization'] = user.authentication_token.to_s
  end

  describe 'GET #index' do
    context 'when listing invoices is successful' do
      let(:invoices) { create_list(:invoice, 3, user_id: user.id, date: '2022-12-23') }

      it 'returns a success response with the list of invoices' do
        allow(Invoice::ListByUserId).to receive(:call).with(user_id: user.id, filter_options: {}).and_return(
          Micro::Case::Result::Success.new(type: :invoices_found, data: { invoices: invoices })
        )

        get :index

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['invoices'].size).to eq(3)
        expect(JSON.parse(response.body)['message']).to eq('Invoices retrieved.')
      end
    end

    context 'when listing invoices fails' do
      it 'returns an error response with the failure message' do
        allow(Invoice::ListByUserId).to receive(:call).with(user_id: user.id, filter_options: {}).and_return(
          Micro::Case::Result::Failure.new(type: :failure)
        )

        get :index

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq({ 'data' => { 'invoices' => [] }, 'message' => 'Failed to list invoices.' })
      end
    end
  end

  describe 'GET #show' do
    context 'when retrieving a specific invoice is successful' do
      it 'returns a success response with the invoice details' do
        allow(Invoice::FindById).to receive(:call).with(invoice_id: '1', user_id: user.id).and_return(
          Micro::Case::Result::Success.new(data: { invoice: { id: 1, number: '123' } })
        )

        get :show, params: { id: '1' }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq({ 'data' => { 'invoice' => { 'id' => 1, 'number' => '123' } }, 'message' => 'Invoice retrieved.' })
      end
    end

    context 'when retrieving a specific invoice fails' do
      it 'returns an error response with the failure message' do
        allow(Invoice::FindById).to receive(:call).with(invoice_id: '1', user_id: user.id).and_return(
          Micro::Case::Result::Failure.new(type: :invoice_not_found)
        )

        get :show, params: { id: '1' }

        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Invoice not found.' })
      end
    end
  end

  describe 'POST #create_and_send_email' do
    context 'when creating and sending email for an invoice is successful' do
      let(:invoice) { create(:invoice, number: '123', date: '2023-12-01', company: 'Test Company', billing_to: 'Test Billing', total_amount: 100) }
      let(:invoice_params) do
        {
          'billing_to' => 'Test Billing',
          'company' => 'Test Company',
          'date' => '2023-12-01',
          'emails' => 'john@example.com',
          'number' => '123',
          'total_amount' => '100.0'
        }
      end

      it 'returns a success response with the created invoice and success message' do
        allow(Invoice::CreateAndSendEmail).to receive(:call).with(invoice_params.to_h.merge(user_id: user.id)).and_return(
          Micro::Case::Result::Success.new(data: { invoice: invoice })
        )

        post :create_and_send_email, params: { invoice_record: invoice_params }

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['invoice']['id']).to eq(invoice.id)
        expect(JSON.parse(response.body)['message']).to eq('Invoice created and email sent successfully.')
      end
    end

    context 'when creating and sending email for an invoice fails' do
      let(:invoice_params) do
        {
          'billing_to' => 'Test Billing',
          'company' => 'Test Company',
          'date' => '2023-12-01',
          'emails' => 'john@example.com',
          'number' => '123',
          'total_amount' => '100.0'
        }
      end

      it 'returns an error response with the failure message' do
        allow(Invoice::CreateAndSendEmail).to receive(:call).with(invoice_params.merge(user_id: user.id)).and_return(
          Micro::Case::Result::Failure.new(type: :invoice_creation_failed)
        )

        post :create_and_send_email, params: { invoice_record: invoice_params }

        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Failed to create invoice or send email.' })
      end
    end
  end
end
