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

  # 管理者側のルーティング設定
  namespace :admin do
  end

  # ユーザー側のルーティング
  scope module: :public do
    root to: "home#top"
    resources :users, only: [:create, :show, :edit, :update, :destroy]
    #get "users/my_page" => "users#show", as: "my_page"
    #get "users/my_page/edit" => "users#edit", as: "my_page_edit"
    resources :posts, only: [:index, :create, :show, :edit, :update, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
