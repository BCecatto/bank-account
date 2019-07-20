# frozen_string_literal: true

require 'rails_helper'

describe Account, type: :model do
  it 'expect valid account' do
    account = FactoryBot.create(:account)
    expect(account).to be_valid
  end
end
