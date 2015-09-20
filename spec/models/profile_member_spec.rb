require 'rails_helper'

RSpec.describe ProfileMember, type: :model do
  subject(:profile_member) { FactoryGirl.create(:profile_member) }

  it { is_expected.to be_valid }

  describe '#profile' do
    it 'belongs to a Profile' do
      expect(profile_member.profile).to be_a(Profile)
    end

    it 'is required' do
      profile_member.profile = nil
      expect(profile_member.valid?).to be(false)
    end
  end

  describe '#member_profile' do
    it 'belongs to a Profile' do
      profile_member.member_profile = FactoryGirl.create(:profile)
      expect(profile_member.member_profile).to be_a(Profile)
    end

    it 'is not required' do
      profile_member.member_profile = nil
      expect(profile_member.valid?).to be(true)
    end
  end

  describe '#member_user' do
    it 'belongs to a User' do
      profile_member.member_user = FactoryGirl.create(:user)
      expect(profile_member.member_user).to be_a(User)
    end

    it 'is not required' do
      profile_member.member_user = nil
      expect(profile_member.valid?).to be(true)
    end
  end

  describe '#added_by' do
    it 'belongs to a Profile' do
      profile_member.added_by = FactoryGirl.create(:profile)
      expect(profile_member.added_by).to be_a(Profile)
    end

    it 'is not required' do
      profile_member.added_by = nil
      expect(profile_member.valid?).to be(true)
    end
  end

  describe '#member' do
    let(:member_user) { FactoryGirl.create(:user) }
    let(:member_profile) { FactoryGirl.create(:profile) }

    before(:each) { profile_member.member_user = member_user }

    context '#member_profile is set' do
      before(:each) { profile_member.member_profile = member_profile }

      it 'is the member_profile' do
        expect(profile_member.member.id).to eq(member_profile.id)
        expect(profile_member.member).to be_a(Profile)
      end
    end

    context '#member_profile is not set' do
      it 'is the member_user' do
        expect(profile_member.member.id).to eq(member_user.id)
        expect(profile_member.member).to be_a(User)
      end
    end
  end
end
