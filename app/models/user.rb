class User < Sequel::Model
  one_to_many :auth_methods
end
