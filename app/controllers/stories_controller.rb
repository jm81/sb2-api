class StoriesController < APIController
  wrap_parameters :story, include: [:body, :direction, :parent_id],
    format: :json

  version 1

  PUBLIC_ACTIONS = [:index, :show, :word_count]
  before_action :require_authenticated, except: PUBLIC_ACTIONS
  before_action :require_profile, except: PUBLIC_ACTIONS

  def index
    expose Story.eager(:author).all, each_serializer: StorySerializer
  end

  def show
    expose Story[params[:id]], serializer: StorySerializer
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

  def word_count
    if params[:level].present?
      level = params[:level]
    elsif params[:parent_id]
      level = Story[params[:parent_id]].level_for_child params[:direction]
    end

    expose Story.word_count_check(params[:body], level)
  end

  private

  def story_params
    params.require(:story).permit(:body, :direction, :parent_id)
  end
end
