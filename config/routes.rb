Rails.application.routes.draw do
  # Devise の設定
  devise_for :users

  # 募集機能
  resources :requests, only: %i[index new create]

  # Items（商品の CRUD ＋マイページ＋削除確認）のルーティング
  resources :items do
    # 自分の出品一覧
    collection do
      get :my
    end

    # 削除確認用ページ
    member do
      get :confirm_destroy
    end
  end

  # 提案 (Offers) ＋返信 (Replies)
  resources :offers do
    post :accept, on: :member
    resources :replies, only: %i[create]
  end

  # メッセージ機能
  resources :messages, only: %i[index create]

  # ホーム
  get "home/index"
  root to: "home#index"
end
