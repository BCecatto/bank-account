# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    account
    operation { 'deposit' }
    value { 100.0 }
    balance { 100.0 }
  end
end
