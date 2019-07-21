# frozen_string_literal: true

require 'rails_helper'

describe Event, type: :model do
  it 'expect valid event' do
    event = FactoryBot.create(:event)
    expect(event).to be_valid
  end
end
