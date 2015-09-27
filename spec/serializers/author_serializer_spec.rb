require 'rails_helper'

RSpec.describe AuthorSerializer do
  let(:author) do
    FactoryGirl.create(:profile, display_name: 'Test Name')
  end

  subject(:serializer) { AuthorSerializer.new(author) }

  it 'renders json, including author' do
    expect(serializer.to_json).to eq({
      author: {
        id: author.id, display_name: 'Test Name', handle: author.handle
      }
    }.to_json)
  end
end
