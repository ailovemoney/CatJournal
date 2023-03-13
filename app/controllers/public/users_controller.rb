# frozen_string_literal: true

class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]

  def create
  end

  def show
    @user = current_user
    @post = Post.new
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  # ゲストユーザーがURLからeditに飛ぼうとしても飛べないようにする記述
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end

end
