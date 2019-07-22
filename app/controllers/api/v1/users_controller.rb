# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      before_action :authorize_request!

      def transfer
        response = TransferService.execute(
          source_account_id: source_account_id,
          destination_account_id: user_params[:destination_account_id],
          amount: user_params[:amount]
        )
        if response
          render json: I18n.t('message.api.transfer.success'), status: :ok
        else
          render json: I18n.t('message.api.transfer.failed'), status: :ok
        end
      end

      private

      def source_account_id
        user_params[:source_account_id] || current_user.account.id
      end

      def user_params
        params.permit(
          :name, :username, :email, :password, :password_confirmation,
          :source_account_id, :destination_account_id, :amount
        )
      end
    end
  end
end
