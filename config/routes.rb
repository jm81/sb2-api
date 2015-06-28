Rails.application.routes.draw do
  api version: 1 do
    resources :stories, only: [:index, :show]
  end
end
