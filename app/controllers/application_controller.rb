# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # ログインしていない場合はアクセスを禁止。
  #before_action :authenticate_user!, except: [:top], if: :user_url
#   before_action :authenticate_admin!, if: :admin_url

#   def user_url
#     if request.fullpath.include?("/admin")
#       print('---------')
#       print('user false')
#       false
#     else
#       print('---------')
#       print('user true')
#       request.fullpath.include?("/user") ? true : false
#     end
#   end

#   def admin_url
#     request.fullpath.include?("/admin") ? true : false
#   end
 end
