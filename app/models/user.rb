# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :account

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
end
