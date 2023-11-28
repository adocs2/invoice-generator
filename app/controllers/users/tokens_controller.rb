# frozen_string_literal: true

module Users
  class TokensController < ApplicationController
    def sign_in
      render('users/sign_in')
    end

    def generate_token_and_send_activation
      result = User::GenerateTokenAndSendActivationEmail.call(email: params[:email])

      if result.success?
        flash[:success] = result[:message]
      else
        flash[:error] = 'Erro ao gerar token e enviar email.'
      end

      redirect_to users_sign_in_path
    end

    def activate_user
      result = User::ActivateToken.call(email: params[:email], activation_token: params[:activation_token])

      if result.success?
        flash[:success] = 'Token ativado com sucesso.'
      else
        flash[:error] = 'Erro ao ativar token.'
      end

      redirect_to users_sign_in_path
    end

    def login_with_token
      result = User::LoginWithToken.call(token: params[:token])

      if result.success?
        flash[:success] = 'Usuário logado com sucesso.'
      else
        flash[:error] = 'Erro ao logar com token.'
      end

      redirect_to users_sign_in_path
    end
  end
end
