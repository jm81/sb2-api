require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.build(:user) }

  it { is_expected.to be_valid }

  describe '#auth_methods' do
    before(:each) { user.save }

    let!(:auth_method) do
      user.add_auth_method(provider: :test, provider_id: 1)
    end

    it 'has many' do
      expect(auth_method).to be_a(AuthMethod)
      expect(user.auth_methods).to eq([auth_method])
      expect(AuthMethod[auth_method.id].user).to eq(user)
    end

    it 'cascades deletes' do
      user.destroy
      expect(AuthMethod[auth_method.id]).to be(nil)
    end
  end

  describe '#auth_tokens' do
    before(:each) { user.save }

    let!(:auth_token) do
      user.add_auth_token(
        auth_method: FactoryGirl.create(:auth_method), last_used_at: Time.now
      )
    end

    it 'has many' do
      expect(auth_token).to be_a(AuthToken)
      expect(user.auth_tokens).to eq([auth_token])
      expect(AuthToken[auth_token.id].user).to eq(user)
    end

    it 'restricts deletes' do
      expect { user.destroy }.
        to raise_error(Sequel::ForeignKeyConstraintViolation)
    end
  end

  describe '.find_by_email' do
    let!(:existing) { FactoryGirl.create(:user, email: 'test@example.com') }

    context 'existing User with given email' do
      it 'gets existing User' do
        expect(User.find_by_email('test@example.com')).to eq(existing)
        expect(User.find_by_email('  test@example.com ')).to eq(existing)
        expect(User.find_by_email('TEST@example.com')).to eq(existing)
      end
    end

    context 'no existing User with given email' do
      it 'is nil' do
        expect(User).to receive(:where).twice.and_call_original
        expect(User.find_by_email('other@example.com')).to be(nil)
        expect(User.find_by_email('test@example.org')).to be(nil)
      end
    end

    context 'nil email' do
      it 'is nil' do
        expect(User).to_not receive(:where)
        expect(User.find_by_email(nil)).to be(nil)
      end
    end

    context 'invalid email' do
      it 'is nil' do
        expect(User).to_not receive(:where)
        expect(User.find_by_email('')).to be(nil)
        expect(User.find_by_email('@example.com')).to be(nil)
        expect(User.find_by_email('test')).to be(nil)
      end
    end
  end
end
