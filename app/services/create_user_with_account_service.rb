# frozen_string_literal: true

class CreateUserWithAccountService
  def self.execute(params:)
    new(params)
      .send(:execute)
  end

  private

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def execute
    ActiveRecord::Base.transaction do
      user = create_user
      account = create_account(user.id)
      create_first_event(account.id)
      true
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error e.message
    false
  end

  def create_user
    User.create!(
      name: params[:name],
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )
  end

  def create_account(user_id)
    Account.create!(
      account_number: params[:account][:account_number],
      bank_number: params[:account][:bank_number],
      user_id: user_id
    )
  end

  def create_first_event(account_id)
    Event.create!(
      account_id: account_id,
      operation: 'deposit',
      value: params[:event][:value] || 0.0,
      balance: params[:event][:value] || 0.0
    )
  end
end
