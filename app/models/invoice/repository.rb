# frozen_string_literal: true

module Invoice::Repository
  extend self

  AsReadonly = ->(invoice) { invoice&.tap(&:readonly!) }

  def create_invoice(number:, date:, company:, billing_to:, total_amount:, user_id:)
    invoice = ::Invoice::Record.new(
      number: number,
      date: date,
      company: company,
      billing_to: billing_to,
      total_amount: total_amount,
      user_id: user_id
    )
    if invoice.save
      invoice.then(&AsReadonly)
    else
      false
    end
  end

  def find_invoice_by_id(id)
    find_invoice_by(id: id) if id
  end

  def find_invoices_by_user_id(user_id, options = {})
    conditions = { user_id: user_id }
    conditions[:date] = options[:date] if options.key?(:date)
    conditions[:number] = options[:number] if options.key?(:number)

    find_invoices_by(conditions)
  end

  private

  def find_invoice_by(conditions)
    ::Invoice::Record.find_by(conditions).then(&AsReadonly)
  end

  def find_invoices_by(conditions)
    ::Invoice::Record.where(conditions).then { |invoices| invoices.map(&AsReadonly) }
  end
end
