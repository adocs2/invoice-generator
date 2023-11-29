# frozen_string_literal: true

module Invoices
  class InvoicesController < ApplicationController
    before_action :require_login

    def new
      @invoice = Invoice::Record.new
    end

    def index
      result = Invoice::ListByUserId.call(user_id: current_user.id, filter_options: filter_params.to_h)

      if result.success?
        @invoices = result[:invoices]
      else
        flash[:error] = 'Failed to list invoices.'
        @invoices = []
      end
    end

    def show
      result = Invoice::FindById.call(invoice_id: params[:id], user_id: current_user.id)

      if result.success?
        @invoice = result[:invoice]
      else
        flash[:error] = 'Invoice not found.'
        redirect_to invoices_path
      end
    end

    def create_and_send_email
      result = Invoice::CreateAndSendEmail.call(invoice_params.to_h.merge(user_id: current_user.id))

      if result.success?
        flash[:success] = 'Invoice created and email sent successfully.'
        redirect_to invoice_path(result[:invoice].id)
      else
        flash[:error] = 'Failed to create invoice or send email.'
        redirect_to new_invoice_path
      end
    end

    private

    def filter_params
      params.permit(:date, :number)
    end

    def invoice_params
      params.require(:invoice_record).permit(:number, :date, :company, :billing_to, :total_amount, :emails)
    end

    def require_login
      redirect_to root_path, notice: 'Please log in' unless current_user
    end
  end
end
