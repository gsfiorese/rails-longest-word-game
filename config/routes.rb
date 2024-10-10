Rails.application.routes.draw do
  resources :games, only: [:new] do
    collection do
      post 'score', action: :score
    end
  end
end
