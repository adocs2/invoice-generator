# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'Hello, World!'
    end
  end

  describe '#current_user' do
    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        allow(User::FindById).to receive(:call).with(session[:user_id]).and_return(user)
      end

      it 'assigns the current user' do
        get :index
        expect(controller.send(:current_user)).to eq(user)
      end
    end

    context 'when user is not logged in' do
      before do
        allow(User::FindById).to receive(:call).with(session[:user_id]).and_return(nil)
      end

      it 'does not assign the current user' do
        get :index
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end
end
