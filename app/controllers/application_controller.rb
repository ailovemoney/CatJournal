# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # ログインしていない場合はアクセスを禁止。
  #before_action :authenticate_user!, except: [:top]
end
