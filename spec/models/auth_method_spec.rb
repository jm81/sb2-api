require 'rails_helper'

RSpec.describe AuthMethod, type: :model do
  subject(:auth_method) { FactoryGirl.build(:auth_method) }

  it { is_expected.to be_valid }

  describe '#user' do
    it 'belongs to a User' do
      expect(auth_method.user).to be_a(User)
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
end
