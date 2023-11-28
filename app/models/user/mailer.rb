# frozen_string_literal: true

class User::Mailer < ApplicationMailer
  def activation_email
    user = params[:user]
    activation_token = user.activation_token
    authentication_token = user.authentication_token

    mail(to: user.email, subject: 'Ative sua conta') do |format|
      format.html do
        url = users_activate_user_url(email: user.email, activation_token: activation_token)

        render('users/mailer/activation_email', locals: { token: authentication_token, url: url })
      end
    end
  end
end
