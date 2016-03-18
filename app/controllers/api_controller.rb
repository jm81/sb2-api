class APIController < RocketPants::Base
  include ActionController::ParamsWrapper

  before_action :set_current_auth_token

  private

  # @return [User] Current user, from @current_auth_token, if any.
  def current_user
    @current_auth_token.try(:user)
  end

  # @return [Profile] Current profile, which is current_user's default profile.
  # @todo allow setting particular profile.
  def current_profile
    current_user.try(:default_profile)
  end

  # Set @current_auth_token by passing encoded token from Authorization header,
  # if any, to AuthToken.use.
  def set_current_auth_token
    token = request.headers['Authorization'].to_s.split(' ').last
    @current_auth_token = token && AuthToken.use(token)
  end

  # Requite an authenticated user or return unauthenticated error.
  def require_authenticated
    error! :unauthenticated if current_user.nil?
  end

  # Requite an authenticated user or return missing profile error.
  def require_profile
    error! :missing_profile if current_profile.nil?
  end
end
