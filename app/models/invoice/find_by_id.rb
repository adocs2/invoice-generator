# frozen_string_literal: true

class Invoice::FindById < Micro::Case
  attribute :invoice_id
  attribute :user_id
  attribute :repository, {
    default: ::Invoice::Repository,
    validates: { kind: { respond_to: :find_invoice_by_id } }
  }

  def call!
    view_invoice
  end

  private

  def view_invoice
    invoice = repository.find_invoice_by_id(invoice_id, user_id)

    return Failure(:invoice_not_found) unless invoice

    Success(:invoice_found, result: { invoice: invoice })
  end
end
