# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    user_id = session[:user_id]
    return nil unless user_id

    result = User::FindById.call(id: user_id)
    result.success? ? result[:user] : nil
  end
end
