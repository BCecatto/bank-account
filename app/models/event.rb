# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :account

  validates :operation, inclusion: { in: %w[withdrawal deposit] }
  validates :value, presence: true
  validates :balance, presence: true
end
