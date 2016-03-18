class StoriesController < APIController
  wrap_parameters :story, include: [:body, :direction, :parent_id],
    format: :json

  version 1

  before_action :require_authenticated, except: [:index, :show]
  before_action :require_profile, except: [:index, :show]

  def index
    expose Story.eager(:author).all, each_serializer: StorySerializer
  end

  def show
    expose Story.find(params[:id]), serializer: StorySerializer
  end

  def create
    story = Story.new story_params
    story.author = current_profile

    if story.valid?
      story.save
      expose story, serializer: StorySerializer
    else
      error! :invalid_resource, story.errors
    end
  end

  private

  def story_params
    params.require(:story).permit(:body, :direction, :parent_id)
  end
end
