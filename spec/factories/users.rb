# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: '::User::Record' do
    email { ::Faker::Internet.email }
    authentication_token { Faker::Alphanumeric.alphanumeric(number: 60) }
  end

  factory :user_with_invoices, parent: :user do
    transient do
      invoices_count { 3 }
    end

    after(:create) do |user, evaluator|
      create_list(:invoice_record, evaluator.invoices_count, user: user)
    end
  end
end