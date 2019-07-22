# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      def authorize_request!
        decoded = JsonWebTokenService.decode(token)

        if different_user_agent?(decoded, request)
          return render json: { errors: 'Unauthorized' }, status: :unauthorized
        end

        @current_user = User.find_by(decoded[:id])
      rescue JWT::DecodeError, JWT::ExpiredSignature,
             ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      end

      attr_reader :current_user

      private

      def different_user_agent?(decoded, request)
        decoded['user_agent'] != request.headers['User-Agent']
      end

      def token
        request.headers['Authorization']
      end
    end
  end
end
