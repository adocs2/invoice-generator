# frozen_string_literal: true

module Users
  class TokensController < ApplicationController
    def generate_token
    end

    def generate_token_and_send_activation
      result = User::GenerateTokenAndSendActivationEmail.call(email: params[:email])

      if result.success?
        flash[:success] = result[:message]
      else
        flash[:error] = 'Erro ao gerar token e enviar email.'
      end

      redirect_to root_path
    end

    def activate_user
      result = User::ActivateToken.call(email: params[:email], activation_token: params[:activation_token])

      if result.success?
        session[:user_id] = result[:user].id
        flash[:success] = 'Token ativado com sucesso.'
        redirect_to invoices_path
      else
        flash[:error] = 'Erro ao ativar token.'
        redirect_to root_path
      end
    end
  end
end
