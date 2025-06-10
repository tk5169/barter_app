# config/routes.rb
Rails.application.routes.draw do
  # トップページ（ホーム）
  get "home/index"
  
  resources :items
  
  root to: "home#index"  # ここは1つだけにする

  # Devise（ユーザー認証）
  devise_for :users
  
  resources :requests, only: %i[index new create]

  # Message（メッセージスレッド用）
  resources :messages, only: [:index, :create]

  # Item（アイテム出品用）
  resources :items do
    collection { get :my }
     end
  
     member do
     get  :confirm_destroy    # 削除確認ページ
     end
 end
  
  resources :offers, only: %i[index show new create edit update destroy] do
    # replies#create が OffersController#create_reply にマップされるように指定
    post "replies", to: "offers#create_reply", as: :replies
  end

  # Offer を受け入れるアクション（カスタムルート）
  post "offers/:id/accept", to: "offers#accept", as: "accept_offer"
　end


