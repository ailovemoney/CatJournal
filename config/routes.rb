# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :public do
    get 'relationships/following'
    get 'relationships/followers'
  end
  # ユーザー用 / コントローラーの指定と余分なルーティングの削除
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # 管理者用 / コントローラーの指定と余分なルーティングの削除
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # ゲストログインの記述
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  # 管理者側のルーティング設定
  namespace :admin do
    resources :users, only: [:index, :edit, :update]
    resources :posts, only: [:index, :edit, :update, :destroy]
    resources :genres, only: [:index, :create, :edit, :update, :destroy]
    resources :post_comments, only: [:index, :destroy]
  end

  # ユーザー側のルーティング
  scope module: :public do
    root to: "home#top"
    # ワード検索用のルーティング↓↓
    get "search" => "searches#search"
    # Userの退会用ルーティング↓↓
    get '/users/confirm' => 'users#confirm'
    patch '/users/withdrawal' => 'users#withdrawal', as: 'withdrawal'
    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        get :favorites
      end
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    resources :genres, only: [:show]
    resources :posts do
      # いいね機能のルーティング↓↓
      # params[:id]不要なため、resourceは単数系で。
      resource :favorites, only: [:create, :destroy]
      # コメント機能のルーティング↓↓
      resources :post_comments, only: [:create, :destroy]
    end
    # 通知機能
    resources :notifications, only: [:index]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
