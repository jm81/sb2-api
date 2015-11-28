class APIController < RocketPants::Base
  include ActionController::ParamsWrapper

  before_action :set_current_auth_token

  private

  # @return [User] Current user, from @current_auth_token, if any.
  def current_user
    @current_auth_token.try(:user)
  end

  # Set @current_auth_token by passing encoded token from Authorization header,
  # if any, to AuthToken.use.
  def set_current_auth_token
    token = request.headers['Authorization'].to_s.split(' ').last
    @current_auth_token = token && AuthToken.use(token)
  end
end
