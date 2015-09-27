class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :handle
end
