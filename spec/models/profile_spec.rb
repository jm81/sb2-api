require 'rails_helper'

RSpec.describe Profile, type: :model do
  subject(:profile) { FactoryGirl.build(:profile) }

  it { is_expected.to be_valid }

  describe '#profile_members' do
    before(:each) { profile.save }

    let!(:profile_member) do
      FactoryGirl.create(:profile_member, profile: profile)
    end

    it 'has many' do
      expect(Profile[profile.id].profile_members).to eq([profile_member])
    end

    it 'cascades deletes' do
      profile.destroy
      expect(ProfileMember[profile_member.id]).to be(nil)
    end
  end

  describe '#member_profiles' do
    before(:each) { profile.save }

    let(:member_profile) { FactoryGirl.create(:profile) }

    let!(:profile_member) do
      FactoryGirl.create(
        :profile_member, profile: profile, member_profile: member_profile
      )
    end

    it 'has many through profile_members' do
      expect(Profile[profile.id].member_profiles).to eq([member_profile])
      expect(Profile[profile.id].member_profiles[0]).to be_a(Profile)
    end

    it 'does not cascade delete' do
      profile.destroy
      expect(Profile[member_profile.id]).to be_a(Profile)
    end
  end

  describe '#member_users' do
    before(:each) { profile.save }

    let(:member_user) { FactoryGirl.create(:user) }

    let!(:user_member) do
      FactoryGirl.create(
        :profile_member, profile: profile, member_user: member_user
      )
    end

    it 'has many through profile_members' do
      expect(Profile[profile.id].member_users).to eq([member_user])
      expect(Profile[profile.id].member_users[0]).to be_a(User)
    end

    it 'does not cascade delete' do
      profile.destroy
      expect(User[member_user.id]).to be_a(User)
    end
  end

  describe '#profile_memberships' do
    before(:each) { profile.save }

    let!(:profile_member) do
      FactoryGirl.create(:profile_member, member_profile: profile)
    end

    it 'has many' do
      expect(Profile[profile.id].profile_memberships).
        to eq([profile_member])
    end

    it 'cascades deletes' do
      profile.destroy
      expect(ProfileMember[profile_member.id]).to be(nil)
    end
  end

  describe '#profiles' do
    before(:each) { profile.save }

    let!(:profile_member) do
      FactoryGirl.create(:profile_member, member_profile: profile)
    end

    it 'has many through profile_members' do
      expect(Profile[profile.id].profiles).to eq([profile_member.profile])
      expect(Profile[profile.id].profiles[0]).to be_a(Profile)
    end

    it 'does not cascade delete' do
      profile.destroy
      expect(Profile[profile_member.profile_id]).to be_a(Profile)
    end
  end

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
