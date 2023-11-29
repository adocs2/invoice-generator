# frozen_string_literal: true

module Invoice
  class CreateAndSendEmail < Micro::Case
    attributes :number, :date, :company, :billing_to, :total_amount, :user_id, :emails
    attribute :repository, {
      default: Invoice::Repository,
      validates: { kind: { respond_to: :create_invoice } }
    }

    def call!
      create_invoice
        .then { |result| result.success? ? send_invoice_email(result[:invoice]) : result }
    end

    private

    def create_invoice
      invoice = repository.create_invoice(
        number: number,
        date: date,
        company: company,
        billing_to: billing_to,
        total_amount: total_amount,
        user_id: user_id
      )

      if invoice
        Success(:invoice_created, result: { invoice: invoice })
      else
        Failure(:invoice_creation_failed, result: { error_message: 'Invoice creation failed' })
      end
    end

    def send_invoice_email(invoice)
      email_array = emails.split(',').map(&:strip)
      email_array.each do |email|
        ::Invoice::Mailer.send_invoice(invoice, email).deliver_now
      end

      Success(:invoice_email_sent, result: { invoice: invoice })
    rescue StandardError => e
      Failure(:invoice_email_failed, result: { error_message: e.message })
    end
  end
end
