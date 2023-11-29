# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }

  controller do
    def index
      render plain: 'Hello, World!'
    end
  end

  describe '#current_user' do
    context 'when user is logged in' do
      before do
        allow(User::FindById).to receive(:call).and_return(Micro::Case::Result::Success.new(data: { user: user }))
        session[:user_id] = user.id
      end

      it 'assigns the current user' do
        get :index
        expect(controller.send(:current_user)).to eq(user)
      end
    end

    context 'when user is not logged in' do
      before do
        allow(User::FindById).to receive(:call).and_return(Micro::Case::Result::Failure.new(type: :user_not_found))
        session[:user_id] = nil
      end

      it 'does not assign the current user' do
        get :index
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end
end
