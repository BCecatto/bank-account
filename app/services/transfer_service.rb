# frozen_string_literal: true

class TransferService
  def self.execute(source_account_id:, destination_account_id:, amount:)
    new(source_account_id, destination_account_id, amount)
      .send(:execute)
  end

  private

  attr_reader :source_account_id, :destination_account_id, :amount

  def initialize(source_account_id, destination_account_id, amount)
    @source_account_id = source_account_id
    @destination_account_id = destination_account_id
    @amount = amount
  end

  def execute
    return false if same_account? || params_blank?

    ActiveRecord::Base.transaction do
      Event.withdrawal(amount: amount, account_id: source_account.id)
      Event.deposit(amount: amount, account_id: destination_account.id)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    Rails.logger.error e.message
    false
  end

  def source_account
    @source_account ||= Account.find(source_account_id)
  end

  def destination_account
    @destination_account ||= Account.find(destination_account_id)
  end

  def same_account?
    source_account_id == destination_account_id
  end

  def params_blank?
    destination_account_id.blank? || amount.blank?
  end
end
