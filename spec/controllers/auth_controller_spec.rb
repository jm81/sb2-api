require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let(:auth_token) { FactoryGirl.create(:auth_token) }
  let(:oauth) { double('oauth') }
  let(:expected_params) do
    {'code' => 'CODE', 'controller' => 'auth'}
  end

  describe 'get github' do
    def do_get
      get :github, code: 'CODE'
    end

    it 'return a json resource' do
      expect(OAuth::Github).to receive(:new).
        with(expected_params.merge('action' => 'github')) { oauth }
      expect(User).to receive(:oauth_login).with(oauth) { auth_token }
      do_get
      expect(response.body).to eq({ token: auth_token.encoded }.to_json)
    end
  end
end
