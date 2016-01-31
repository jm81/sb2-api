module ControllerMacros
  def set_auth_token_header
    before(:each) do
      request.headers['Authorization'] = "Bearer #{session_auth_token.encoded}"
    end
  end

  def use_auth_token
    let(:session_auth_token) do
      profile_member = FactoryGirl.create :profile_member
      FactoryGirl.create :auth_token, user: profile_member.member_user
    end

    set_auth_token_header
  end

  def use_auth_token_without_profile
    let(:session_auth_token) { FactoryGirl.create :auth_token }
    set_auth_token_header
  end
end
