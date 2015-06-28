require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  let!(:story) { FactoryGirl.create(:story) }
  let(:stories) { [story, FactoryGirl.create(:story)] }

  describe 'get index' do
    before(:each) { stories }

    def do_get
      get :index, version: 1
    end

    it 'returns a json collection' do
      do_get
      expect(response).to be_collection_resource
      expect(response).to have_exposed(stories)
    end
  end

  describe 'get show' do
    def do_get
      get :show, version: 1, id: story.id
    end

    it 'return a json resource' do
      do_get
      expect(response).to be_singular_resource
      expect(response).to have_exposed(story)
    end
  end
end
