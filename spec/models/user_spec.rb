# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  it 'expect valid user' do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end
end
