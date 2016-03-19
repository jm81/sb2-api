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

  describe '#parent' do
    it 'can belong to a parent Story' do
      story.parent = FactoryGirl.create(:story)
      expect(story.parent).to be_a(Story)
    end
  end

  describe '#children' do
    it 'has many children Stories' do
      story.save
      children = FactoryGirl.create_list(:story, 2, parent: story)
      expect(Story[story.id].children).to eq(children)
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

  describe '#body=' do
    it 'sets words' do
      story.body = 'Hello, there. How are you?'
      expect(story.words).to eq(5)
      story.body = "Mrs. Watts-Up is here to see y'all"
      expect(story.words).to eq(7)
    end

    it 'sets body' do
      story.body = 'Hi, Worlds'
      expect(story.body).to eq('Hi, Worlds')
    end
  end

  describe '#set_level_from_direction' do
    before(:each) do
      story.level = nil
      story.parent = FactoryGirl.create :story, level: 4
    end

    context '@direction is missing' do
      it 'does nothing' do
        story.send :set_level_from_direction
        expect(story.level).to be(nil)
      end
    end

    context 'parent is missing' do
      it 'does nothing' do
        story.direction = '+'
        story.parent = nil
        story.send :set_level_from_direction
        expect(story.level).to be(nil)
      end
    end

    context '@direction is +' do
      it 'sets level to parent level plus 1' do
        story.direction = '+'
        story.send :set_level_from_direction
        expect(story.level).to be(5)
      end
    end

    context '@direction is -' do
      it 'sets level to parent level minus 1' do
        story.direction = '-'
        story.send :set_level_from_direction
        expect(story.level).to be(3)
      end
    end

    it 'is called by validate' do
      story.direction = '-'
      expect(story.level).to be(nil)
      story.valid?
      expect(story.level).to be(3)
    end
  end

  describe '.word_count' do
    it 'gets a count of words for the text' do
      expect(Story.word_count('Hello, there. How are you?')).to eq(5)
      expect(Story.word_count("Mrs. Watts-Up is here to see y'all")).to eq(7)
      expect(Story.word_count('')).to eq(0)
      expect(Story.word_count(nil)).to eq(0)
    end
  end
end
