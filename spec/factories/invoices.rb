# frozen_string_literal: true

FactoryBot.define do
  factory :invoice, class: '::Invoice::Record' do
    association :user

    sequence(:number) { |n| n }
    date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    company { Faker::Company.name }
    billing_to { Faker::Company.name }
    total_amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
  end
end
