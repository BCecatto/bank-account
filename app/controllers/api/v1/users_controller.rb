# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      before_action :authorize_request!, except: :create

      def create
        response = CreateUserWithAccountService.execute(params: user_params)
        if response
          render json: I18n.t('message.api.user.success').to_json,
                 status: :ok
        else
          render json: I18n.t('activerecord.errors.messages.record_invalid')
                           .to_json, status: :unprocessable_entity
        end
      end

      def transfer
        response = execute_transfer
        if response
          render json: I18n.t('message.api.transfer.success')
                           .to_json, status: :ok
        else
          render json: I18n.t('message.api.transfer.failed')
                           .to_json, status: :ok
        end
      end

      private

      def execute_transfer
        TransferService.execute(
          source_account_id: source_account_id,
          destination_account_id: user_params[:destination_account_id],
          amount: user_params[:amount]
        )
      end

      def source_account_id
        user_params[:source_account_id] || current_user.account.id
      end

      def user_params
        params.permit(
          :name, :username, :email, :password, :source_account_id,
          :destination_account_id, :amount,
          account: %i[
            account_number bank_number
          ],
          event: [
            :value
          ]
        )
      end
    end
  end
end
