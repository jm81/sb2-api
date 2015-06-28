class StoriesController < RocketPants::Base
  version 1

  def index
    expose Story.all
  end

  def show
    expose Story.find(params[:id])
  end
end
