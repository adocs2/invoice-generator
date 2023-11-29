# RSpec.describe Invoice::CreateAndSendEmail do
#   let(:repository) { class_double(Invoice::Repository) }
#   let(:mailer) { class_double(Invoice::Mailer) }

#   describe '#call!' do
#     subject(:use_case) { described_class }

#     context 'when creating invoice is successful' do
#       let(:user) { create(:user, id: 1) }
#       let(:invoice) { create(:invoice, user: user) }

#       before do
#         allow(repository).to receive(:create_invoice).and_return(invoice)
#         allow(mailer).to receive(:send_invoice)
#       end

#       it 'returns a success result' do
#         result = use_case.call(
#           number: 123,
#           date: Date.today,
#           company: 'ABC Corp',
#           billing_to: 'John Doe',
#           total_amount: 100.00,
#           user_id: 1,
#           emails: 'john@example.com, jane@example.com'
#         )

#         expect(result).to be_success
#         expect(result[:invoice]).to eq(invoice)
#       end

#       it 'creates the invoice and sends email' do
#         expect(repository).to receive(:create_invoice).once
#         expect(mailer).to receive(:send_invoice).twice

#         use_case.call(
#           number: 123,
#           date: Date.today,
#           company: 'ABC Corp',
#           billing_to: 'John Doe',
#           total_amount: 100.00,
#           user_id: 1,
#           emails: 'john@example.com, jane@example.com'
#         )
#       end
#     end

#     context 'when creating invoice fails' do
#       before do
#         allow(repository).to receive(:create_invoice).and_return(nil)
#       end

#       it 'returns a failure result' do
#         result = use_case.call(
#           number: 123,
#           date: Date.today,
#           company: 'ABC Corp',
#           billing_to: 'John Doe',
#           total_amount: 100.00,
#           user_id: 1,
#           emails: 'john@example.com, jane@example.com'
#         )

#         expect(result).to be_failure
#         expect(result[:error_message]).to eq('Invoice creation failed')
#       end
#     end

#     context 'when sending email fails' do
#       let(:invoice) { create(:invoice, user: create(:user, id: 1)) }

#       before do
#         allow(repository).to receive(:create_invoice).and_return(invoice)
#         allow(mailer).to receive(:send_invoice).and_raise(StandardError, 'Email sending failed')
#       end

#       it 'returns a failure result' do
#         result = use_case.call(
#           number: 123,
#           date: Date.today,
#           company: 'ABC Corp',
#           billing_to: 'John Doe',
#           total_amount: 100.00,
#           user_id: 1,
#           emails: 'john@example.com, jane@example.com'
#         )

#         expect(result).to be_failure
#         expect(result[:error_message]).to eq('Email sending failed')
#       end
#     end
#   end
# end
