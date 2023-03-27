class Public::PostsController < ApplicationController
  before_action :is_matching_login_user_post, only: [:edit, :update]

  def new
    @post = Post.new
  end

  def index
    @post = Post.new
    # 新着順にソートをかける
    # orderは投稿データの順序、descは並び替えの降順
    # pageはkaminariでページネーションをかけています
    @posts = Post.page(params[:page]).order(created_at: :desc)
    @genres = Genre.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿が成功しました。"
      redirect_to user_path(current_user.id)
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    @users = @post.user
    # コメント機能の登録↓
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update(post_params)
    redirect_to post_path(post.id)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(current_user.id)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :genre_id)
  end

  # ユーザーがURLから他ユーザーの投稿編集ページに飛ぼうとしても飛べないようにする記述
  def is_matching_login_user_post
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to posts_path
    end
  end

end
