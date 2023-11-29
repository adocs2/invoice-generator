# frozen_string_literal: true

class Invoice::Mailer < ApplicationMailer
  def send_invoice(invoice, email)
    invoice_url = 'teste.com'

    pdf_generator = ::Invoice::PdfGenerator.new(invoice)
    attachments['invoice.pdf'] = pdf_generator.generate_pdf.to_s

    mail(to: email, subject: 'Invoice criada com sucesso') do |format|
      format.html do
        invoice_url = 'teste.com'

        render('invoices/mailer/send_invoice', locals: { invoice: invoice, invoice_url: invoice_url, attachments: attachments })
      end
    end
  end
end
