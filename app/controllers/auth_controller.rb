class AuthController < APIController
  version 1

  def github
    @oauth = OAuth::Github.new params
    oauth_login
  end

  def logout
    @current_auth_token.try(:close!)
    head :ok
  end

  def session
    render_json({
      user_id: current_user.id,
      display_name: current_user.display_name,
    })
  end

  private

  # Get and render an AuthToken, using User.oauth_login.
  def oauth_login
    @token = User.oauth_login @oauth
    render_json({ token: @token.encoded })
  end
end
