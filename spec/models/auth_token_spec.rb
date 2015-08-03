require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  subject(:auth_token) { FactoryGirl.build(:auth_token) }

  it { is_expected.to be_valid }

  describe '#auth_method' do
    it 'belongs to a AuthMethod' do
      expect(auth_token.auth_method).to be_a(AuthMethod)
    end
  end

  describe '#user' do
    it 'belongs to a User' do
      expect(auth_token.user).to be_a(User)
    end
  end

  describe '#encoded' do
    before(:each) { auth_token.save }

    it 'returns a String encoding the id' do
      encoded = auth_token.encoded
      expect(auth_token.encoded).to be_a(String)
      decoded = JWT.decode(
        encoded, AuthToken::JWT_SECRET, AuthToken::JWT_ALGORITHM
      )
      expect(decoded[0]).to eq({'auth_token_id' => auth_token.id})
    end
  end

  describe '#expires_at' do
    it 'is 30 days after last_used_at' do
      auth_token.last_used_at = DateTime.parse('2015-08-01 15:00')
      expect(auth_token.expires_at).to eq(DateTime.parse('2015-08-31 15:00'))
    end
  end

  describe '#open? (#expired? is opposite)' do
    context '#last_used_at not set' do
      it 'is false' do
        auth_token.last_used_at = nil
        expect(auth_token.open?).to be(false)
        expect(auth_token.expired?).to be(true)
      end
    end

    context '#last_used_at is more than 30 days ago' do
      it 'is false' do
        auth_token.last_used_at = 31.days.ago
        expect(auth_token.open?).to be(false)
        expect(auth_token.expired?).to be(true)
        auth_token.last_used_at = 131.days.ago
        expect(auth_token.open?).to be(false)
        expect(auth_token.expired?).to be(true)
      end

    end

    context '#last_used_at is less than 30 days ago' do
      it 'is true' do
        auth_token.last_used_at = 29.days.ago
        expect(auth_token.open?).to be(true)
        expect(auth_token.expired?).to be(false)
        auth_token.last_used_at = Time.now
        expect(auth_token.open?).to be(true)
        expect(auth_token.expired?).to be(false)
      end
    end
  end

  describe '.decode' do
    def encoded id
      AuthToken.encode auth_token_id: id
    end

    before(:each) { auth_token.save }

    it 'returns AuthToken based on encoded token' do
      other = FactoryGirl.create(:auth_token)
      expect(AuthToken.decode(encoded(auth_token.id))).to eq(auth_token)
      expect(AuthToken.decode(encoded(auth_token.id))).to_not eq(other)
    end

    context 'auth_token_id missing from decoded hash' do
      it 'raises DecodeError' do
        expect { AuthToken.decode(AuthToken.encode(something: 'else')) }.
          to raise_error(AuthToken::DecodeError)
      end
    end

    context 'No AuthToken found for auth_token_id from decoded hash' do
      it 'raises DecodeError' do
        expect { AuthToken.decode(encoded(-10)) }.
          to raise_error(AuthToken::DecodeError)
      end
    end
  end

  describe '.encode' do
    it 'encodes a value using JWT' do
      encoded = AuthToken.encode({a: 1, b: 2})
      expect(auth_token.encoded).to be_a(String)
      decoded = JWT.decode(
        encoded, AuthToken::JWT_SECRET, AuthToken::JWT_ALGORITHM
      )
      expect(decoded[0]).to eq({'a' => 1, 'b' => 2})
    end
  end

  describe '.use' do
    def encoded id
      AuthToken.encode auth_token_id: id
    end

    before(:each) do
      auth_token.save
    end

    context 'found open AuthToken' do
      before(:each) do
        auth_token.last_used_at = Time.now - 3600
        auth_token.save
      end

      let!(:other) { FactoryGirl.create(:auth_token) }

      it 'updates last_used_at' do
        found = AuthToken.use(encoded(auth_token.id))
        expect(found.last_used_at).to be > Time.now - 600
        expect(found.last_used_at.to_i).
          to eq(auth_token.reload.last_used_at.to_i)
      end

      it 'returns found AuthToken' do
        expect(AuthToken.use(encoded(auth_token.id))).to be === auth_token
        expect(AuthToken.use(encoded(auth_token.id))).to_not be === other
      end
    end

    context 'found expired AuthToken' do
      before(:each) do
        auth_token.last_used_at = 40.days.ago.to_time
        auth_token.save
      end

      let!(:last_used_at) { auth_token.last_used_at }

      it 'does not update last_used_at' do
        AuthToken.use(encoded(auth_token.id))
        expect(auth_token.reload.last_used_at.to_i).to eq(last_used_at.to_i)
      end

      it 'returns nil' do
        expect(AuthToken.use(encoded(auth_token.id))).to be(nil)
      end
    end

    context 'No AuthToken found for auth_token_id from decoded hash' do
      it 'raises DecodeError' do
        expect { AuthToken.use(encoded(-10)) }.
          to raise_error(AuthToken::DecodeError)
      end
    end
  end
end
