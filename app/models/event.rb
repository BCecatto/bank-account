# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :account

  validates :operation, inclusion: { in: %w[withdrawal deposit] }
  validates :value, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def self.withdrawal(amount:, account_id:)
    ActiveRecord::Base.transaction do
      account = Account.find(account_id)
      create!(
        account_id: account.id,
        operation: 'withdrawal',
        value: amount, 
        balance: account.events.last.balance - amount
      )
    end
  end

  def self.deposit(amount:, account_id:)
    ActiveRecord::Base.transaction do
      account = Account.find(account_id)
      create!(
        account_id: account.id,
        operation: 'deposit',
        value: amount, 
        balance: account.events.last.balance + amount
      )
    end
  end
end
