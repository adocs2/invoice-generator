# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid authentication token' do
      let(:user) { create(:user) } # Assuming you have a FactoryBot factory for User

      it 'logs in the user and redirects to dashboard' do
        post :create, params: { authentication_token: user.authentication_token }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(invoices_path)
        expect(flash[:notice]).to eq('Logged in successfully')
      end
    end

    context 'with invalid authentication token' do
      it 'renders new template with an error message' do
        post :create, params: { authentication_token: 'invalid_token' }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash[:error]).to eq('Invalid token or user not activated')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'logs out the user and redirects to root' do
      session[:user_id] = 1
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Logged out successfully')
    end
  end
end
