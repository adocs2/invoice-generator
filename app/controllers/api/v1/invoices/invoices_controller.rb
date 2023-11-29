# frozen_string_literal: true

module Api::V1::Invoices
  class InvoicesController < Api::V1::BaseController
    before_action :authenticate_user

    def index
      result = Invoice::ListByUserId.call(user_id: @current_user.id, filter_options: filter_params.to_h)

      if result.success?
        render(json: { data: { invoices: result[:invoices] }, message: 'Invoices retrieved.' }, status: 200)
      else
        render(json: { data: { invoices: [] }, message: 'Failed to list invoices.' }, status: 400)
      end
    end

    def show
      result = Invoice::FindById.call(invoice_id: params[:id], user_id: @current_user.id)

      if result.success?
        render(json: { data: { invoice: result[:invoice] }, message: 'Invoice retrieved.' }, status: 200)
      else
        render(json: { message: 'Invoice not found.' }, status: 404)
      end
    end

    def create_and_send_email
      result = Invoice::CreateAndSendEmail.call(invoice_params.to_h.merge(user_id: @current_user.id))

      if result.success?
        render(json: { data: { invoice: result[:invoice] }, message: 'Invoice created and email sent successfully.' }, status: 200)
      else
        render(json: { message: 'Failed to create invoice or send email.' }, status: 400)
      end
    end

    private

    def filter_params
      params.permit(:date, :number)
    end

    def invoice_params
      params.require(:invoice_record).permit(:number, :date, :company, :billing_to, :total_amount, :emails)
    end

    def authenticate_user
      authorization_header = request.headers['Authorization']
      if authorization_header
        @current_user = User::LoginWithToken.call(authentication_token: authorization_header)[:user]
      else
        render json: { error: 'Token inválido ou não ativado.' }, status: :unauthorized
      end
    end
  end
end
