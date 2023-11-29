# frozen_string_literal: true

module Invoice
  class ListByUserId < Micro::Case
    attribute :user_id
    attribute :filter_options
    attribute :repository, {
      default: ::Invoice::Repository,
      validates: { kind: { respond_to: :find_invoices_by_user_id } }
    }

    def call!
      cleaned_filter_options = clean_filter_options(filter_options)
      list_invoices(cleaned_filter_options)
    end

    private

    def list_invoices(filter_options)
      invoices = repository.find_invoices_by_user_id(user_id, filter_options)

      Success(:invoices_found, result: { invoices: invoices })
    end

    def clean_filter_options(options)
      options.reject { |_, v| v.blank? }
    end
  end
end
