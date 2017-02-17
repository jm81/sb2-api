class AuthMethod < Sequel::Model
  many_to_one :user

  one_to_many :auth_tokens

  # Create AuthToken, setting user and last_used_at
  #
  # @return [AuthToken]
  def create_token
    add_auth_token(user: user, last_used_at: Time.now.utc)
  end

  class << self
    # Get an AuthMethod using provider data conditions (#provider_name and
    # #provider_id). AFAICT, sequel_enum does not handle getting the raw value
    # for the where method, so this method does that conversion.
    #
    # @param provider_data [Hash]
    # @return [AuthMethod]
    def by_provider_data provider_data
      where(provider_data).first
    end
  end
end
