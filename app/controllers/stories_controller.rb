class StoriesController < APIController
  version 1

  def index
    expose Story.eager(:author).all, each_serializer: StorySerializer
  end

  def show
    expose Story.find(params[:id]), serializer: StorySerializer
  end
end
