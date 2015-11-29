class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :display_name, :handle
end
