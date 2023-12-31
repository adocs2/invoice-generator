# frozen_string_literal: true

module User
  class GenerateTokenAndSendActivationEmail < Micro::Case
    attributes :email
    attribute :repository, {
      default: User::Repository,
      validates: { kind: { respond_to: :create_user } }
    }

    def call!
      return Failure(:email_empty) if email.empty?

      find_or_create
        .then { |user| send_activation_email(user) }
        .then { Success(result: { message: 'Token gerado com sucesso. Verifique seu email para ativar.' }) }
    end

    private

    def generate_token
      SecureRandom.hex(20)
    end

    def generate_activation_token
      SecureRandom.urlsafe_base64
    end

    def find_or_create
      user = repository.find_user_by_email(email)

      if user.nil?
        user = repository.create_user(email: email, authentication_token: generate_token, activation_token: generate_activation_token)
      else
        repository.change_user_token(user, generate_token, generate_activation_token)
        user.reload
      end

      user
    end

    def send_activation_email(user)
      ::User::Mailer.with(user: user).activation_email.deliver_now
      Success(:email_sent)
    end
  end
end
