Rails.application.routes.draw do
  devise_for :users
  root "homes#top"      # ルートURLを home#index に設定
  get "homes/about" => "homes#about", as: "homes_about"  # Aboutページ
  get "about" => "homes#about", as: "about"
  resources :books        # BooksController に対するRESTfulルーティング
  resources :post_images, only: [:new, :create, :index, :show, :destroy] do
    resource :favorite, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit]
end
