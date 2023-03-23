# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # ログインしていない場合はアクセスを禁止。
  before_action :authenticate_user!, except: [:top], if: :user_url
  before_action :authenticate_admin!, if: :admin_url

  # ユーザーが送信したHTTPリクエストのパスが"/admin"を含んでいる場合はfalse
   def user_url
     if request.fullpath.include?("/admin")
      # URLに"/admin"が含まれている場合の処理
      # ターミナルで確認用の記述
      # print('---------')
      # print('user false')
       false
     else
      # URLに"/admin"が含まれていない場合の
      # print('---------')
      # print('user true')
       request.fullpath.include?("/user") ? true : false
     end
   end

   def admin_url
     request.fullpath.include?("/admin") ? true : false
   end
end
