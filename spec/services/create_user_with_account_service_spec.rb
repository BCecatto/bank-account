# frozen_string_literal: true

require 'rails_helper'

describe CreateUserWithAccountService do
  context '#execute' do
    context 'with correct params' do
      it 'create  a new user with account' do
        params = {
          name: 'Foo', username: 'Bar', email: 'foo@hotmail.com', password: '321321',
          account: {
            account_number: '321', bank_number: '321'
          },
          event: {
            value: 100.0
          }
        }.with_indifferent_access

        expect { CreateUserWithAccountService.execute(params: params) }
          .to change { User.count }
          .by(1)
      end
    end

    context 'with wrong params' do
      it 'trigger error' do
        params = {
          name: 'Foo', username: 'Bar', email: 'foo@hotmail.com', password: nil,
          account: {
            account_number: '321', bank_number: '321'
          },
          event: {
            value: 100.0
          }
        }.with_indifferent_access

        response = CreateUserWithAccountService.execute(params: params)

        expect(response).to eq false
      end
    end
  end
end
