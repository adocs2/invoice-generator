# frozen_string_literal: true

module Invoices
  class InvoicesController < ApplicationController
    before_action :require_login

    def index
      # Your authenticated action logic
    end

    private

    def require_login
      redirect_to new_sessions_path, notice: 'Please log in' unless current_user
    end
  end
end
