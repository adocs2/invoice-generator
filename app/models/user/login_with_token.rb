# frozen_string_literal: true

module User
  class LoginWithToken < Micro::Case
    attributes :authentication_token
    attribute :repository, default: User::Repository

    def call!
      find_and_log_in_user
    end

    private

    def find_and_log_in_user
      user = repository.find_user_by_authentication_token(authentication_token)

      return Failure(:user_not_found) unless user
      return Failure(:invalid_token) unless user.activated?

      Success(:user, result: { user: user })
    end
  end
end
