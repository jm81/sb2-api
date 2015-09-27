require 'rails_helper'

RSpec.describe StorySerializer do
  let(:author) do
    FactoryGirl.create(:profile, display_name: 'Test Name')
  end

  let(:story) do
    FactoryGirl.create(:story, author: author)
  end

  subject(:serializer) { StorySerializer.new(story) }

  it 'renders json, including author' do
    expect(serializer.to_json).to eq({
      story: {
        id: story.id, body: story.body, level: story.level, words: story.words,
        author: {
          id: author.id, display_name: 'Test Name', handle: author.handle
        }
      }
    }.to_json)
  end
end
