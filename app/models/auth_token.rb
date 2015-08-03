class AuthToken < Sequel::Model
  EXPIRES_SECONDS = 30 * 86400
  JWT_SECRET = Rails.application.secrets.jwt_secret
  JWT_ALGORITHM = Rails.application.secrets.jwt_algorithm

  class DecodeError < StandardError
  end

  many_to_one :auth_method
  many_to_one :user

  # @return [String]
  #   { auth_token_id: self.id } encoded via JWT for passing to client.
  def encoded
    self.class.encode auth_token_id: self.id
  end

  # @return [Boolean] Is this token expired?
  def expired?
    !open?
  end

  # @return [Boolean] True if token is not expired.
  def open?
    !(last_used_at.nil?) && Time.now <= expires_at
  end

  # @return [DateTime] Time when this token expires.
  def expires_at
    last_used_at + EXPIRES_SECONDS
  end

  class << self

    # Decode a JWT token and get AuthToken based on stored ID.
    #
    # @see #encoded
    # @param token [String] JWT encoded hash with AuthToken#id
    # @raise [DecodeError] auth_token_id is missing or no AuthToken found.
    # @return [AuthToken]
    def decode token
      payload = JWT.decode(token, JWT_SECRET, JWT_ALGORITHM).first
      auth_token = self[payload['auth_token_id']]

      if payload['auth_token_id'].nil?
        raise DecodeError, "auth_token_id missing: #{payload}"
      elsif auth_token.nil?
        raise DecodeError, "auth_token_id not found: #{payload}"
      end

      auth_token
    end

    # Encode a value using JWT_SECRET and JWT_ALGORITHM.
    #
    # @param value [Hash, Array]
    # @return [String] Encoded value
    def encode value
      JWT.encode value, JWT_SECRET, JWT_ALGORITHM
    end

    # Decode a JWT token and get AuthToken based on stored ID. If an open
    # AuthToken is found, update its last_used_at value.
    #
    # @see #decode
    # @param token [String] JWT encoded hash with AuthToken#id
    # @raise [DecodeError] auth_token_id is missing or no AuthToken found.
    # @return [AuthToken]
    def use token
      auth_token = decode token

      if auth_token && !auth_token.expired?
        auth_token.update(last_used_at: Time.now)
        auth_token
      else
        nil
      end
    end
  end
end
