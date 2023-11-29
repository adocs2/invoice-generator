# frozen_string_literal: true

module Users
  class SessionsController < ApplicationController
    def new
    end

    def create
      result = User::LoginWithToken.call(authentication_token: params[:authentication_token])

      if result.success?
        session[:user_id] = result[:user].id
        redirect_to root_path, notice: 'Logged in successfully'
      else
        flash.now[:error] = 'Invalid token or user not activated'
        render :new
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: 'Logged out successfully'
    end
  end
end
