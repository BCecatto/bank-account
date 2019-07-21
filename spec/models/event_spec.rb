# frozen_string_literal: true

require 'rails_helper'

describe Event, type: :model do
  it 'expect valid event' do
    event = FactoryBot.create(:event)
    expect(event).to be_valid
  end

  context '#withdrawal' do
    context 'have enought balance to transaction' do
      it 'execute with success' do
        balance = 100.0
        withdrawal = 30.0
        event = FactoryBot.create(:event, balance: balance)
        account = event.account
        
        Event.withdrawal(amount: withdrawal, account_id: account.id)

        expect(account.reload.events.last.balance).to eq balance - withdrawal
      end
    end
    
    context 'dont have enought balance to transaction' do
      it 'raise RecordInvalid' do
        event = FactoryBot.create(:event)
        account = event.account
        
        expect{ Event.withdrawal(amount: 30.0, account_id: account.id) }
          .to raise_error(
            ActiveRecord::RecordInvalid,
            'Validation failed: Balance must be greater than or equal to 0'
          )
      end
    end
  end

  context '#deposit' do
    context 'sum deposit to your balance' do
      it 'execute with success' do
        balance = 100.0
        deposit = 30.0
        event = FactoryBot.create(:event, balance: balance)
        account = event.account
        
        Event.deposit(amount: deposit, account_id: account.id)

        expect(account.reload.events.last.balance).to eq balance + deposit
      end
    end
  end
end
