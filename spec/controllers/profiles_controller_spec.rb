require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:profile) { FactoryGirl.build(:profile) }

  let(:valid_params) do
    { handle: profile.handle, display_name: profile.display_name }
  end

  let(:invalid_params) do
    { handle: '', display_name: profile.display_name }
  end

  describe 'post create' do
    def do_post
      post :create, { profile: post_params, version: 1, format: :json }
    end

    describe 'valid params' do
      use_auth_token

      let(:post_params) { valid_params }

      it 'creates a profile' do
        expect { do_post }.to change(Profile, :count).by(1)
        created = Profile.order_prepend(:id).last
        expect(created.handle).to eq(profile.handle)
        expect(created.display_name).to eq(profile.display_name)
      end

      it 'assigns profile to current_user' do
        do_post
        profile_users = Profile.order_prepend(:id).last.member_users
        expect(profile_users.first).to be_a(User)
        expect(profile_users).to eq([session_auth_token.user])
      end

      it 'it renders profile' do
        do_post
        created = Profile.order_prepend(:id).last
        expect(response.body).to eq({
          response: ProfileSerializer.new(created).serializable_hash
        }.to_json)
      end
    end

    describe 'invalid params' do
      use_auth_token

      let(:post_params) { invalid_params }

      it 'does not create a profile' do
        expect { do_post }.to_not change(Profile, :count)
      end

      it 'renders errors' do
        do_post
        expect(response.body).to match('invalid_resource')
      end
    end

    describe 'no logged in user' do
      let(:post_params) { valid_params }

      it 'renders unauthenticated error' do
        expect { do_post }.to_not change(Profile, :count)
        expect(response.body).to match('unauthenticated')
      end
    end
  end
end
