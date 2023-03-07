Rails.application.routes.draw do
  # ユーザー用 / コントローラーの指定と余分なルーティングの削除
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
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
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
