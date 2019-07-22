# frozen_string_literal: true

module Api
  module V1
    class AccountsController < Api::V1::ApplicationController
      before_action :authorize_request!

      def balance
        account = Account.find(account_id)
        render json: I18n.t('message.api.account.balance',
                            value: last_balance(account)).to_json, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: I18n.t('message.api.account.not_found').to_json,
               status: :not_found
      end

      private

      def last_balance(account)
        account.events.last.balance
      end

      def account_id
        account_params[:id] || current_user.id
      end

      def account_params
        params.permit(:id)
      end
    end
  end
end
