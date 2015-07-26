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
end
