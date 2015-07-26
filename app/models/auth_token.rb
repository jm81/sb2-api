class AuthToken < Sequel::Model
  many_to_one :auth_method
  many_to_one :user
end
