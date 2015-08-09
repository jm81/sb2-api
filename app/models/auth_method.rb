class AuthMethod < Sequel::Model
  plugin :enum

  many_to_one :user

  one_to_many :auth_tokens

  PROVIDERS = { 1 => :test, 2 => :github }
  enum :provider_name, PROVIDERS

  # Create AuthToken, setting user and last_used_at
  #
  # @return [AuthToken]
  def create_token
    add_auth_token(user: user, last_used_at: Time.now.utc)
  end
end
