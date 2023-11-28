# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Mailer, type: :mailer do
  let(:user) { FactoryBot.create(:user, email: 'user@example.com', activation_token: 'abc123', authentication_token: 'xyz456') }

  describe 'activation_email' do
    let(:mail) { described_class.with(user: user).activation_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Ative sua conta')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com']) # Adjust this to your actual sender email
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include('Ative sua conta')
      expect(mail.body.encoded).to include('Olá')
      expect(mail.body.encoded).to include('Seu token para login é: xyz456')
      expect(mail.body.encoded).to include('Clique no link abaixo para ativar sua conta:')
      expect(mail.body.encoded).to include('<a href="http://localhost:3000/users/activate_user?activation_token=abc123&email=user@example.com">Ativar Conta</a>')
    end
  end
end
