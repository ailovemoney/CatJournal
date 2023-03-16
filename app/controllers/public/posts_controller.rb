class Public::PostsController < ApplicationController

  def index
    @post = Post.new
    @posts = Post.all
    @genres = Genre.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save!
      redirect_to user_path(current_user.id)
    else
      # render 'new'
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

end
