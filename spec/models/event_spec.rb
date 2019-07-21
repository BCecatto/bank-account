# frozen_string_literal: true

require 'rails_helper'

describe Event, type: :model do
  it 'expect valid event' do
    event = FactoryBot.create(:event)
    expect(event).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:account) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_inclusion_of(:operation).in_array(%w[withdrawal deposit]) }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
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
        event = FactoryBot.create(:event, balance: 25.0)
        account = event.account

        expect { Event.withdrawal(amount: 30.0, account_id: account.id) }
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
