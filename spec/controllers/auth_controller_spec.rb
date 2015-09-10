require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let(:auth_token) { FactoryGirl.create(:auth_token) }
  let(:oauth) { double('oauth') }
  let(:expected_params) do
    {
      'code' => 'CODE', 'controller' => 'auth', 'version' => '1',
     'format' => 'json'
    }
  end

  describe 'post github' do
    def do_post
      post :github, code: 'CODE', version: 1, format: :json
    end

    it 'return a json resource' do
      expect(OAuth::Github).to receive(:new).
        with(expected_params.merge('action' => 'github')) { oauth }
      expect(User).to receive(:oauth_login).with(oauth) { auth_token }
      do_post
      expect(response.body).to eq({ token: auth_token.encoded }.to_json)
    end
  end

  describe '#logout' do
    use_auth_token

    it 'closes @current_auth_token' do
      expect(session_auth_token.open?).to be(true)

      post :logout, version: 1

      expect(session_auth_token.reload.closed_at).to be_a(Time)
      expect(session_auth_token.open?).to be(false)
    end

    it 'renders head :ok' do
      expect(response.status).to eq(200)
      expect(response.body).to eq('')
    end
  end

  describe '#session' do
    use_auth_token

    before(:each) do
      session_auth_token.user.update(display_name: 'test name')
    end

    it 'renders json with session information' do
      get :session, version: 1

      expect(response.body).to eq({
        user_id: session_auth_token.user.id,
        display_name: 'test name'
      }.to_json)
    end
  end
end
