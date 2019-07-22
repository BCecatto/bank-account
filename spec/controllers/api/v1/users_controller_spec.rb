# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  context 'Authentication' do
    context 'when have a valid JWT' do
      it 'get current user' do
        user = FactoryBot.create(:user)

        token = JsonWebTokenService.encode(
          user_id: user.id,
          user_agent: 'Ubuntu'
        )

        request.headers['User-Agent'] = 'Ubuntu'
        request.headers['Authorization'] = token

        source_account_initial_event = FactoryBot.create(:event, balance: 100.0)
        source_account = source_account_initial_event.account
        destination_account_initial_event = FactoryBot.create(:event, balance: 100.0)
        destination_account = destination_account_initial_event.account

        post :transfer, params: {
          source_account_id: source_account.id,
          destination_account_id: destination_account.id,
          amount: 50
        }

        expect(subject.current_user).to eq user
      end
    end

    context 'when have a different user agent' do
      it 'status unauthorized' do
        user = FactoryBot.create(:user)

        token = JsonWebTokenService.encode(
          user_id: user.id,
          user_agent: 'Ubuntu'
        )

        request.headers['User-Agent'] = 'Debian'
        request.headers['Authorization'] = token

        post :transfer, params: {
          source_account_id: 123,
          destination_account_id: 321,
          amount: 50
        }

        expect(response).to have_http_status(:unauthorized)
        expect(subject.current_user).to eq nil
      end
    end

    context 'when dont have a valid JWT' do
      it 'status unauthorized' do
        user = FactoryBot.create(:user)

        token = JsonWebTokenService.encode(
          user_id: user.id,
          user_agent: 'Ubuntu'
        )

        request.headers['User-Agent'] = 'Debian'
        request.headers['Authorization'] = token + 'concat_to_invalid'

        post :transfer, params: {
          source_account_id: 123,
          destination_account_id: 321,
          amount: 50
        }

        expect(response).to have_http_status(:unauthorized)
        expect(subject.current_user).to eq nil
      end
    end
  end

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

          expect(response.body).to eq I18n.t('message.api.transfer.success').to_json
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

          expect(response.body).to eq I18n.t('message.api.transfer.failed').to_json
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
          source_account_id: 12_354,
          destination_account_id: 1234,
          amount: 150
        }

        expect(response.body).to eq I18n.t('message.api.transfer.failed').to_json
      end
    end
  end

  context '#create' do
    context 'when params is' do
      it 'valid create with success a new user with account' do
        params = {
          name: 'Foo', username: 'Bar', email: 'foo@hotmail.com', password: '321321',
          account: {
            account_number: '321', bank_number: '321'
          },
          event: {
            value: 100.0
          }
        }.with_indifferent_access

        post :create, params: params

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(I18n.t('message.api.user.success'))
      end

      it 'invalid return error' do
        params = {
          name: 'Foo', username: 'Bar', email: nil, password: '321321',
          account: {
            account_number: '321', bank_number: '321'
          },
          event: {
            value: 100.0
          }
        }.with_indifferent_access

        post :create, params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(I18n.t('activerecord.errors.messages.record_invalid'))
      end
    end
  end
end
