# frozen_string_literal: true

module Invoice
  class PdfGenerator
    include ActionView::Helpers::NumberHelper

    def initialize(invoice)
      @invoice = invoice
    end

    def generate_pdf
      pdf = WickedPdf.new.pdf_from_string(pdf_html)
      save_path = Rails.root.join('public', 'invoices', "invoice_#{@invoice.id}.pdf")
      File.open(save_path, 'wb') do |file|
        file << pdf
      end
      save_path
    end

    private

    def pdf_html
      ApplicationController.new.render_to_string(
        template: 'invoices/pdf',
        layout: 'pdf_layout',
        locals: { invoice: @invoice }
      )
    end
  end
end
