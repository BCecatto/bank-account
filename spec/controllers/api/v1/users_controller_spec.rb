# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  context '#transfer' do
    context 'when source account' do
      context 'have enought money to transfer' do
        it 'return success' do
          allow_any_instance_of(Api::V1::UsersController)
            .to receive(:authorize_request!)
            .and_return(true)

          source_account_initial_event = FactoryBot.create(:event, balance: 100.0)
          source_account = source_account_initial_event.account
          destination_account_initial_event = FactoryBot.create(:event, balance: 100.0)
          destination_account = destination_account_initial_event.account

          post :transfer, params: {
            source_account_id: source_account.id,
            destination_account_id: destination_account.id,
            amount: 50
          }

          expect(response.body).to eq I18n.t('message.api.transfer.success')
          expect(source_account.events.last.balance).to eq 50
          expect(destination_account.events.last.balance).to eq 150
        end
      end

      context 'dont have enought money to transfer' do
        it 'return failed and dont change any account balance' do
          allow_any_instance_of(Api::V1::UsersController)
            .to receive(:authorize_request!)
            .and_return(true)

          source_account_initial_event = FactoryBot.create(:event, balance: 100.0)
          source_account = source_account_initial_event.account
          destination_account_initial_event = FactoryBot.create(:event, balance: 100.0)
          destination_account = destination_account_initial_event.account

          post :transfer, params: {
            source_account_id: source_account.id,
            destination_account_id: destination_account.id,
            amount: 150
          }

          expect(response.body).to eq I18n.t('message.api.transfer.failed')
          expect(source_account.events.last.balance).to eq 100
          expect(destination_account.events.last.balance).to eq 100
        end
      end
    end

    context 'account dont exist' do
      it 'render error' do
        allow_any_instance_of(Api::V1::UsersController)
          .to receive(:authorize_request!)
          .and_return(true)
        
        post :transfer, params: {
          source_account_id: 12354,
          destination_account_id: 1234,
          amount: 150
        }

        expect(response.body).to eq I18n.t('message.api.transfer.failed')
      end
    end
  end
end
