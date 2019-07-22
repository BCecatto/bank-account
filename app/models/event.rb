# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :account

  validates :operation, inclusion: { in: %w[withdrawal deposit] }
  validates :value, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def self.withdrawal(amount:, account_id:)
    create!(
      account_id: account_id,
      operation: 'withdrawal',
      value: amount,
      balance: Event.where(account_id: account_id)
        .last.balance - amount.to_f
    )
  end

  def self.deposit(amount:, account_id:)
    create!(
      account_id: account_id,
      operation: 'deposit',
      value: amount,
      balance: Event.where(account_id: account_id)
        .last.balance + amount.to_f
    )
  end
end
