require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject(:profile) { FactoryGirl.build(:profile) }

  it { is_expected.to be_valid }

  describe '#handle' do
    it 'is required' do
      profile.handle = nil
      expect(profile.valid?).to be(false)
      profile.handle = ''
      expect(profile.valid?).to be(false)
    end

    it 'cannot be longer than 15 characters' do
      profile.handle = 'a' * 15
      expect(profile.valid?).to be(true)
      profile.handle = 'a' * 16
      expect(profile.valid?).to be(false)
    end

    it 'must consist of only letters, numbers and underscores' do
      profile.handle = '_1bc_2A'
      expect(profile.valid?).to be(true)
      profile.handle = '_1bc _2a'
      expect(profile.valid?).to be(false)
      profile.handle = '_1bc-2a'
      expect(profile.valid?).to be(false)
      profile.handle = '_1bc*2a'
      expect(profile.valid?).to be(false)
    end

    it 'is unique (case-insensitive)' do
      existing = FactoryGirl.create(:profile)
      profile.handle = existing.handle
      expect(profile.valid?).to be(false)
      profile.handle = existing.handle.upcase
      expect(profile.valid?).to be(false)
    end
  end

  describe '#display_name' do
    it 'is required' do
      profile.display_name = nil
      expect(profile.valid?).to be(false)
      profile.display_name = ''
      expect(profile.valid?).to be(false)
    end

    it 'cannot be longer than 40 characters' do
      profile.display_name = 'a' * 40
      expect(profile.valid?).to be(true)
      profile.display_name = 'a' * 41
      expect(profile.valid?).to be(false)
    end
  end
end