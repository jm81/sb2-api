class StoriesController < APIController
  version 1

  def index
    expose Story.all
  end

  def show
    expose Story.find(params[:id])
  end
end
