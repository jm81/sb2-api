class StorySerializer < ActiveModel::Serializer
  attributes :id, :body, :level, :words

  has_one :author, serializer: ProfileSerializer
end
