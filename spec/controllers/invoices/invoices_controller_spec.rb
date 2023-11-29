# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoices::InvoicesController, type: :controller do
  let(:user) { create(:user) }
  let(:invoice) { create(:invoice, user: user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    context 'when the user has invoices' do
      let!(:invoices) { create_list(:invoice, 3, user: user) }

      it 'calls the Invoice::ListByUserId case with the user id and filter params' do
        filter_params = { date: '2023-11-29', number: '123' }
        expect(Invoice::ListByUserId).to receive(:call).with(user_id: user.id, filter_options: filter_params).and_call_original
        get :index, params: filter_params
      end

      it 'assigns the invoices to @invoices' do
        get :index
        expect(assigns(:invoices)).to match_array(invoices)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when the user has no invoices' do
      it 'calls the Invoice::ListByUserId case with the user id and filter params' do
        filter_params = { date: '2023-11-29', number: '123' }
        expect(Invoice::ListByUserId).to receive(:call).with(user_id: user.id, filter_options: filter_params).and_call_original
        get :index, params: filter_params
      end

      it 'assigns an empty array to @invoices' do
        get :index
        expect(assigns(:invoices)).to be_empty
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'POST #create_and_send_email' do
    context 'when the invoice is valid and the email is sent' do
      let(:invoice_params) do
        {
          'billing_to' => 'John Doe',
          'company' => 'ACME',
          'date' => '2023-11-29',
          'emails' => 'john@example.com',
          'number' => '123',
          'total_amount' => '100.0'
        }
      end

      it 'calls the Invoice::CreateAndSendEmail case with the invoice params and user id' do
        expect(Invoice::CreateAndSendEmail).to receive(:call).with(invoice_params.to_h.merge(user_id: user.id)).and_call_original
        post :create_and_send_email, params: { invoice_record: invoice_params }
      end

      it 'sets a flash success message' do
        post :create_and_send_email, params: { invoice_record: invoice_params }
        expect(flash[:success]).to eq('Invoice created and email sent successfully.')
      end

      it 'redirects to the invoice show path' do
        post :create_and_send_email, params: { invoice_record: invoice_params }
        expect(response).to redirect_to(invoice_path(Invoice::Record.last.id))
      end
    end

    context 'when the invoice is invalid or the email is not sent' do
      let(:invoice_params) do
        {
          number: '',
          date: '',
          company: '',
          billing_to: '',
          total_amount: '',
          emails: ''
        }
      end

      it 'calls the Invoice::CreateAndSendEmail case with the invoice params and user id' do
        expect(Invoice::CreateAndSendEmail).to receive(:call).with(invoice_params.to_h.merge(user_id: user.id)).and_call_original
        post :create_and_send_email, params: { invoice_record: invoice_params }
      end

      it 'sets a flash error message' do
        post :create_and_send_email, params: { invoice_record: invoice_params }
        expect(flash[:error]).to eq('Failed to create invoice or send email.')
      end

      it 'redirects to the new invoice path' do
        post :create_and_send_email, params: { invoice_record: invoice_params }
        expect(response).to redirect_to(new_invoice_path)
      end
    end
  end
end
