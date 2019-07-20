# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AuthenticationsController, type: :controller do
  context '#login' do
    context 'send params of a valid user' do
      it 'return a JWT' do
        password = '321123'
        user = FactoryBot.create(:user, password: password)

        post :login, params: { email: user.email, password: password }
        response_parsed = JSON.parse(response.body)

        expect(response_parsed).to have_key('token')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'send wrong user informations' do
      it 'return unauthorized' do
        password = '321123'
        user = FactoryBot.create(:user, password: password)

        post :login, params: { email: user.email, password: 'other_password' }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
