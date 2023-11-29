# frozen_string_literal: true

module Api::V1::Users
  class TokensController < Api::V1::BaseController
    def generate_token_and_send_activation
      result = User::GenerateTokenAndSendActivationEmail.call(email: params[:email])

      if result.success?
        render(json: { message: result[:message] }, status: 200)
      else
        render(json: { message: 'Erro ao gerar token e enviar email.' }, status: 400)
      end
    end

    def activate_user
      result = User::ActivateToken.call(email: params[:email], activation_token: params[:activation_token])

      if result.success?
        render(json: { data: { authentication_token: result[:user].authentication_token }, message: 'Token ativado com sucesso.' }, status: 200)
      else
        render(json: { message: 'Erro ao ativar token.' }, status: 400)
      end
    end
  end
end
