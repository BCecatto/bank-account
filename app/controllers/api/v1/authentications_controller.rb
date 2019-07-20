# frozen_string_literal: true

module Api
  module V1
    class AuthenticationsController < Api::V1::ApplicationController
      def login
        user = find_user
        if user&.authenticate(login_params[:password])
          token = JsonWebTokenService.encode(params_to_encode(user))
          time = Time.now + 24.hours.to_i
          render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M'),
                         username: user.username }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      private

      def find_user
        User.find_by_email(login_params[:email])
      end

      def params_to_encode(user)
        { user_id: user.id, user_agent: request.headers['User-Agent'] }
      end

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
