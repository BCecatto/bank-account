# frozen_string_literal: true

module Api
  module V1
    class AccountsController < Api::V1::ApplicationController
      before_action :authorize_request!

      def balance
        account = Account.find(account_params[:id])
        render json: I18n.t(
          'message.api.account.balance',
          value: account.events.last.balance
        ), status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: I18n.t('message.api.account.not_found'),
               status: :not_found
      end

      private

      def account_params
        params.permit(:id)
      end
    end
  end
end
