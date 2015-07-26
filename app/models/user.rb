class User < Sequel::Model
  EMAIL_REGEX = /.@./
  one_to_many :auth_methods
  one_to_many :auth_tokens

  class << self
    # Find user by email address. Returns nil if the email address is not
    # valid (for a minimal version of valid)
    #
    # @param email [~to_s] Email Address
    # @return [User, nil]
    def find_by_email email
      if email.to_s =~ EMAIL_REGEX
        where(email: email.to_s.downcase.strip).first
      else
        nil
      end
    end
  end
end
