class Admin::PostCommentsController < ApplicationController

  def index
    @post_comments = PostComment.page(params[:page]).order(created_at: :desc)
  end

  def destroy
    @post_comment = PostComment.find(params[:id]).destroy
    @post_comment.destroy
    redirect_to admin_post_comments_path
  end

end
