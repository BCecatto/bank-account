# frozen_string_literal: true

require 'rails_helper'

describe TransferService do
  context '#execute' do
    context 'when source account dont have enought balance value' do
      it 'trigger a error' do
        source_account_initial_event = FactoryBot.create(:event, balance: 100.0)
        destination_account_initial_event = FactoryBot.create(:event, balance: 100.0)

        response = TransferService.execute(
          source_account_id: source_account_initial_event.account.id,
          destination_account_id: destination_account_initial_event.account.id,
          amount: 150.0
        )

        expect(response).to be_falsey
      end
    end

    context 'when source accoutn have enought balance value' do
      it 'realize operation with success' do
        source_account_initial_event = FactoryBot.create(:event, balance: 100.0)
        source_account = source_account_initial_event.account
        destination_account_initial_event = FactoryBot.create(:event, balance: 100.0)
        destination_account = destination_account_initial_event.account
        
        TransferService.execute(
          source_account_id: source_account.id,
          destination_account_id: destination_account.id,
          amount: 100.0
        )

        expect(source_account.reload.events.last.balance).to eq 0
        expect(destination_account.reload.events.last.balance).to eq 200
      end
    end

    context 'return false when' do
      it 'amount is nil' do
        source_account_initial_event = FactoryBot.create(:event, balance: 100.0)
        source_account = source_account_initial_event.account
        destination_account_initial_event = FactoryBot.create(:event, balance: 100.0)
        destination_account = destination_account_initial_event.account
        
        response = TransferService.execute(
          source_account_id: source_account.id,
          destination_account_id: destination_account.id,
          amount: nil
        )

        expect(response).to be_falsey
      end

      it 'destination_account is nil' do
        source_account_initial_event = FactoryBot.create(:event, balance: 100.0)
        source_account = source_account_initial_event.account
        
        response = TransferService.execute(
          source_account_id: source_account.id,
          destination_account_id: nil,
          amount: 10.0
        )

        expect(response).to be_falsey
      end
    end
  end
end
