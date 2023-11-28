# frozen_string_literal: true

module User
  class ActivateToken < Micro::Case
    attributes :email, :activation_token
    attribute :repository, default: User::Repository

    def call!
      find_and_activate_user
    end

    private

    def find_and_activate_user
      repository.find_user_by_email(email).then do |user|
        return Failure(:user_not_found) unless user
        return Failure(:activation_token_invalid) unless user.activation_token == activation_token

        repository.activate_user(user, activation_token)
        Success(:user, result: { user: user })
      end
    end
  end
end
