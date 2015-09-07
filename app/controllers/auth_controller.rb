class AuthController < ApplicationController
  def github
    @oauth = OAuth::Github.new params
    oauth_login
  end

  private

  # Get and render an AuthToken, using User.oauth_login.
  def oauth_login
    @token = User.oauth_login @oauth
    render json: { token: @token.encoded }
  end
end
