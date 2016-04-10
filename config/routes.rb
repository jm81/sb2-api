Rails.application.routes.draw do
  api version: 1 do
    resources :profiles, only: [:create]

    resources :stories, only: [:index, :show, :create] do
      collection do
        get :word_count
        post :word_count
      end
    end

    get 'auth', to: 'auth#session'
    post 'auth/logout', to: 'auth#logout'
  end

  post 'auth/github', to: 'auth#github', version: 1
end
