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

  describe 'post create' do
    use_auth_token

    def do_post
      post :create, version: 1, story: attributes
    end

    let(:attributes) do
      { body: 'hi there', parent_id: story.id, direction: '+' }
    end

    context 'valid params' do
      let(:created_story) { Story.order_prepend(:id).last }

      it 'creates a Story' do
        expect { do_post }.to change(Story, :count).by(1)
        expect(created_story.body).to eq('hi there')
        expect(created_story.parent).to eq(story)
      end

      it 'sets level of new story based on direction' do
        do_post
        expect(created_story.level).to be(story.level + 1)
      end

      it 'sets author from profile' do
        do_post
        expect(created_story.author).to be_a(Profile)
        expect(created_story.author).to eq(session_profile)
      end

      it 'returns a json resource for created Story' do
        do_post
        expect(response).to be_singular_resource
        expect(response.body).to eq({
          response: StorySerializer.new(created_story).serializable_hash
        }.to_json)
      end
    end

    context 'invalid params' do
      let(:attributes) do
        { body: 'hi there', direction: '+' }
      end

      it 'does not create a Story' do
        expect { do_post }.to_not change(Story, :count)
      end

      it 'renders invalid resource with errors' do
        do_post
        expect(response.body).to include('invalid_resource')
      end
    end

    context 'no authenticated user' do
      clear_auth_token

      it 'does not create Story' do
        expect { do_post }.to_not change(Story, :count)
        expect(response.body).to match('unauthenticated')
      end
    end

    context 'no session profile' do
      use_auth_token_without_profile

      it 'does not create Story' do
        expect { do_post }.to_not change(Story, :count)
        expect(response.body).to match('missing_profile')
      end
    end
  end
end
