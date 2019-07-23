# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::AccountsController, type: :controller do
  def balance_checker(account_id:)
    events = Event.where(account_id: account_id)
    values_event_deposit = events.select { |e| e.operation == 'deposit' }.pluck(:value)
    values_event_withdrawal = events.select { |e| e.operation == 'withdrawal' }.pluck(:value)
    values_event_deposit.inject(:+) - values_event_withdrawal.inject(:+)
  end

  context '#balance' do
    context 'get balance of account' do
      it 'with success' do
        allow_any_instance_of(Api::V1::AccountsController)
          .to receive(:authorize_request!)
          .and_return(true)

        deposit_value = 100.0
        withdrawal_value = 34.0
        number_of_deposits = 10
        number_of_withdrawal = 5
        account = FactoryBot.create(:event).account

        number_of_deposits.times do
          Event.deposit(amount: deposit_value, account_id: account.id)
        end

        number_of_withdrawal.times do
          Event.withdrawal(amount: withdrawal_value, account_id: account.id)
        end

        get :balance, params: { id: account.id }

        expect(response.body).to include(balance_checker(account_id: account.id).to_s)
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
