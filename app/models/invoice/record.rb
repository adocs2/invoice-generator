# frozen_string_literal: true

module Invoice
  class Record < ApplicationRecord
    self.table_name = 'invoices'
    belongs_to :user, class_name: '::User::Record'

    validates :number, uniqueness: { scope: :user_id, case_sensitive: true }
    validates :number, presence: true
    validates :date, presence: true
    validates :company, presence: true
    validates :billing_to, presence: true
    validates :total_amount, presence: true
  end
end
