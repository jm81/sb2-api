require 'rails_helper'

RSpec.describe Story, type: :model do
  subject(:story) { FactoryGirl.build(:story) }

  it { is_expected.to be_valid }

  describe '#author' do
    it 'belongs to an Profile' do
      expect(story.author).to be_a(Profile)
    end

    it 'is required' do
      story.author = nil
      expect(story).to_not be_valid
      expect(story.errors.on(:author).length).to eq(1)
    end
  end

  describe '#level' do
    context 'missing' do
      it 'fails validation' do
        story.level = nil
        expect(story).to_not be_valid
        expect(story.errors.on(:level).length).to eq(1)
      end
    end

    context 'negative' do
      it 'fails validation' do
        story.level = nil
        expect(story).to_not be_valid
        expect(story.errors.on(:level).length).to eq(1)
      end
    end
  end
end
