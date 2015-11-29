require 'rails_helper'

RSpec.describe ProfileSerializer do
  let(:profile) do
    FactoryGirl.create(:profile, display_name: 'Test Name')
  end

  subject(:serializer) { ProfileSerializer.new(profile) }

  it 'renders json, including profile' do
    expect(serializer.to_json).to eq({
      profile: {
        id: profile.id, display_name: 'Test Name', handle: profile.handle
      }
    }.to_json)
  end
end
