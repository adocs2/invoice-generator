# frozen_string_literal: true

module User
  class Record < ApplicationRecord
    self.table_name = 'users'
    has_secure_token :authentication_token
    has_many :invoices, dependent: :destroy, inverse_of: :user, class_name: '::Invoice::Record', foreign_key: 'user_id'

    validates :email, presence: true, uniqueness: true
    validates :authentication_token, presence: true, uniqueness: true
  end
end
