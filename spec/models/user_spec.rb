# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  it 'expect valid user' do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  describe 'associations' do
    it { should have_one(:account) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end
end
