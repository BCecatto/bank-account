# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::ApplicationController, type: :controller do
  context 'when have a valid JWT' do
    it 'get current user' do
      user = FactoryBot.create(:user)

      token = JsonWebTokenService.encode(
        user_id: user.id,
        user_agent: 'Ubuntu'
      )

      request_mock =
        {
          'User-Agent' => 'Ubuntu',
          'Authorization' => token
        }

      allow_any_instance_of(ActionController::TestRequest)
        .to receive(:headers)
        .and_return(request_mock)

      subject.authorize_request!

      expect(subject.current_user).to eq user
    end
  end

  context 'when have a different user agent' do
    it 'status Unauthorized' do
      user = FactoryBot.create(:user)

      token = JsonWebTokenService.encode(
        user_id: user.id,
        user_agent: 'Ubuntu'
      )

      request_mock =
        {
          'User-Agent' => 'Debian',
          'Authorization' => token
        }

      allow_any_instance_of(ActionController::TestRequest)
        .to receive(:headers)
        .and_return(request_mock)

      subject.authorize_request!

      expect(subject.current_user).to eq nil
    end
  end

  context 'when dont have a valid JWT' do
    it 'status Unauthorized' do
      user = FactoryBot.create(:user)

      token = JsonWebTokenService.encode(
        user_id: user.id,
        user_agent: 'Ubuntu'
      )

      request_mock =
        {
          'User-Agent' => 'Debian',
          'Authorization' => token + 'concat_to_invalid'
        }

      allow_any_instance_of(ActionController::TestRequest)
        .to receive(:headers)
        .and_return(request_mock)

      subject.authorize_request!

      expect(subject.current_user).to eq nil
    end
  end
end
