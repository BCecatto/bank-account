# frozen_string_literal: true

require 'rails_helper'

describe JsonWebTokenService do
  describe '.encode' do
    it 'encodes an object and decode with success' do
      user = { id: 1 }
      encoded = JsonWebTokenService.encode(user)

      expect(encoded).to be_kind_of(String)

      decoded = JsonWebTokenService.decode(encoded)

      expect(decoded[:id]).to eq(user[:id])
    end
  end

  describe '.decode' do
    it 'decode with failure' do
      user = { id: 1 }
      encoded = JsonWebTokenService.encode(user)

      expect(encoded).to be_kind_of(String)

      expect { JsonWebTokenService.decode(encoded + 'concat_invalid_value') }
        .to raise_error(JWT::VerificationError)
    end
  end
end
