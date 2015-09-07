RSpec.shared_examples 'an API action with current user' do
  let(:last_used_at) { Time.now - 300 }
  let(:auth_token) do
    FactoryGirl.create(:auth_token, last_used_at: last_used_at)
  end

  def do_get
    get(*get_args)
  end

  def do_get_with_token
    request.headers['Authorization'] = "Bearer #{auth_token.encoded}"
    do_get
  end

  describe '#current_user' do
    context 'has @current_auth_token' do
      it 'gets user of @current_auth_token' do
        do_get_with_token
        expect(controller.send(:current_user)).to eq(auth_token.user)
        expect(controller.send(:current_user)).to be_a(User)
      end
    end

    context 'no @current_auth_token' do
      it 'is nil' do
        expect(AuthToken).to_not receive(:use)
        do_get
        expect(controller.send(:current_user)).to be(nil)
      end
    end
  end

  describe '#set_current_auth_token' do
    context 'Authorization header' do
      it 'sets @current_auth_token from AuthToken.use' do
        do_get_with_token
        expect(controller.instance_variable_get(:@current_auth_token).id).
          to eq(auth_token.id)
        expect(auth_token.reload.last_used_at).to be > last_used_at
      end
    end

    context 'no Authorization header' do
      it 'is nil' do
        expect(AuthToken).to_not receive(:use)
        do_get
        expect(controller.instance_variable_get(:@current_auth_token)).
          to be(nil)
      end
    end
  end
end
