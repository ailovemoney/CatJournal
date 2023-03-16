# frozen_string_literal: true

Rails.application.routes.draw do
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
    resources :posts, only: [:index]
    resources :genres, only: [:index, :create, :edit, :update, :destroy]
  end

  # ユーザー側のルーティング
  scope module: :public do
    root to: "home#top"
    get "search" => "searchs#saerch"
    resources :users, only: [:show, :edit, :update, :destroy]
    #get "users/my_page" => "users#show", as: "my_page"
    #get "users/my_page/edit" => "users#edit", as: "my_page_edit"
    resources :genres, only: [:show] 
    resources :posts, only: [:index, :create, :show, :edit, :update, :destroy] do
      # いいね機能のルーティング↓↓
      # params[:id]不要なため、resourceは単数系で。
      resource :favorites, only: [:create, :destroy]
      # コメント機能のルーティング↓↓
      resources :post_comments, only: [:create, :destroy]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
