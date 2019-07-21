# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    user
    account_number { FFaker::PhoneNumber.short_phone_number }
    bank_number { FFaker::PhoneNumber.short_phone_number }
  end
end
