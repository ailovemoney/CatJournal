# frozen_string_literal: true

class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]

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

  def favorites
    @user = User.find(params[:id])
    # ユーザーidが、このユーザーの、いいねのレコードを全て取得する。
    # pluckはFavoriteモデルからpost_idを取得
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    # ビューへ渡すための記述
    @favorite_post = Post.find(favorites)
  end

  def withdrawal
    @user = current_user
    # is_deletedカラムをtrueにする
    @user.update(is_deleted: true)
    # sessionは明示的に削除されるまでは消えないため、ここでリセットさせる。
    # sessionはページ遷移しても以前に入力した情報を保持することができる機能。
    reset_session
    flash[:notice] = "退会処理を実行しました"
    redirect_to root_path
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
