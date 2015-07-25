class AuthMethod < Sequel::Model
  plugin :enum

  many_to_one :user

  enum :provider, { 1 => :test, 2 => :github }
end
