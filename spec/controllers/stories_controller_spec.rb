require 'rails_helper'
require 'controllers/shared/auth'

RSpec.describe StoriesController, type: :controller do
  let!(:story) { FactoryGirl.create(:story) }
  let(:stories) { [story, FactoryGirl.create(:story)] }

  describe 'get index' do
    before(:each) { stories }

    def get_args
      [:index, version: 1]
    end

    def do_get
      get(*get_args)
    end

    it_behaves_like 'an API action with current user'

    it 'returns a json collection' do
      do_get
      expect(response).to be_collection_resource
      expect(response.body).to eq({
        response:
          stories.collect { |s| StorySerializer.new(s).serializable_hash },
        count: 2
      }.to_json)
    end
  end

  describe 'get show' do
    def do_get
      get :show, version: 1, id: story.id
    end

    it 'return a json resource' do
      do_get
      expect(response).to be_singular_resource
      expect(response.body).to eq({
        response: StorySerializer.new(story).serializable_hash
      }.to_json)
    end
  end
end
