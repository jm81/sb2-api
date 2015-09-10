module ControllerMacros
  def use_auth_token
    let(:session_auth_token) { FactoryGirl.create(:auth_token) }

    before(:each) do
      request.headers['Authorization'] = "Bearer #{session_auth_token.encoded}"
    end
  end
end
