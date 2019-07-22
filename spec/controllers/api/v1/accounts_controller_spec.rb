# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AccountsController, type: :controller do
  context '#balance' do
    context 'get balance of account' do
      it 'with success' do
        allow_any_instance_of(Api::V1::AccountsController)
          .to receive(:authorize_request!)
          .and_return(true)

        amount = 100.0
        number_of_deposits = 10
        number_of_withdrawal = 2
        account = FactoryBot.create(:event).account

        number_of_deposits.times do
          Event.deposit(amount: amount, account_id: account.id)
        end

        number_of_withdrawal.times do
          Event.withdrawal(amount: amount, account_id: account.id)
        end

        get :balance, params: { id: account.id }

        # first event in factory have 100 of balance by default
        account_balance = ((amount * number_of_deposits + 100) - (number_of_withdrawal * amount)).to_s
        expect(response.body).to include(account_balance)
      end
    end

    context 'account id not found' do
      it 'return messsage and status of not found' do
        allow_any_instance_of(Api::V1::AccountsController)
          .to receive(:authorize_request!)
          .and_return(true)

        invalid_id = 312

        get :balance, params: { id: invalid_id }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq I18n.t('message.api.account.not_found').to_json
      end
    end
  end
end
