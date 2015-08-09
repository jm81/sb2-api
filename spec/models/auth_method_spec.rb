require 'rails_helper'

RSpec.describe AuthMethod, type: :model do
  subject(:auth_method) { FactoryGirl.build(:auth_method) }

  it { is_expected.to be_valid }

  describe '#user' do
    it 'belongs to a User' do
      expect(auth_method.user).to be_a(User)
    end
  end

  describe '#auth_tokens' do
    before(:each) { auth_method.save }

    let!(:auth_token) do
      auth_method.add_auth_token(user: auth_method.user, last_used_at: Time.now)
    end

    it 'has many' do
      expect(auth_token).to be_a(AuthToken)
      expect(auth_method.auth_tokens).to eq([auth_token])
      expect(AuthToken[auth_token.id].auth_method).to eq(auth_method)
    end

    it 'cascades deletes' do
      expect { auth_method.destroy }.
        to raise_error(Sequel::ForeignKeyConstraintViolation)
    end
  end

  describe '#provider' do
    it 'is an enum' do
      { test: 1, github: 2 }.each do |value, index|
        auth_method.provider = value
        expect(auth_method.provider).to eq(value)
        expect(auth_method[:provider]).to eq(index)
      end
    end
  end

  describe '#create_token' do
    before(:each) { auth_method.save }

    it 'creates an AuthToken, setting user and last_used_at' do
      token = nil
      expect { token = auth_method.create_token }.
        to change(AuthToken, :count).by(1)

      token.reload
      expect(token.user).to be_a(User)
      expect(token.user).to eq(auth_method.user)
      expect(token.last_used_at).to be_a(Time)
    end
  end
end
