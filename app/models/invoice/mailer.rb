# frozen_string_literal: true

class Invoice::Mailer < ApplicationMailer
  def send_invoice(invoice, email)
    pdf_generator = ::Invoice::PdfGenerator.new(invoice)
    attachments['invoice.pdf'] = File.read(pdf_generator.generate_pdf)

    mail(to: email, subject: 'Invoice criada com sucesso') do |format|
      format.html do
        render('invoices/mailer/send_invoice', locals: { invoice: invoice, attachments: attachments })
      end
    end
  end
end
