class AuthMethod < Sequel::Model
  plugin :enum

  many_to_one :user

  one_to_many :auth_tokens

  enum :provider, { 1 => :test, 2 => :github }
end
