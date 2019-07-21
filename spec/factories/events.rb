# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    account
    operation { 'withdrawal' }
    value { 1.5 }
    balance { 1.5 }
  end
end
