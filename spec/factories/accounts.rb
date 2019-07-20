# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    user
    balance { 100.3 }
  end
end
