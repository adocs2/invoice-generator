# frozen_string_literal: true

class User::FindById < ::Micro::Case
  attribute :id
  attribute :repository, {
    default: ::User::Repository,
    validates: { kind: { respond_to: :find_user_by_id } }
  }

  def call!
    user = repository.find_user_by_id(id)

    return Failure(:user_not_found) unless user

    Success(:user_found, result: { user: user })
  end
end
