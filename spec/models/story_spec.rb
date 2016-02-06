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

  describe '.word_count' do
    it 'gets a count of words for the text' do
      expect(Story.word_count('Hello, there. How are you?')).to eq(5)
      expect(Story.word_count("Mrs. Watts-Up is here to see y'all")).to eq(7)
    end
  end
end
