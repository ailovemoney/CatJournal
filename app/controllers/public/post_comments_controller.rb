class Public::PostCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    # comment = PostComment.new(post_comment_params)
    # comment.user_id = current_user.id この２行を以下の一行に。
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
    # redirect_to post_path(post) ←非同期通信のため削除
    @post_comment = PostComment.new
    # 通知機能。コメントをしたタイミングで通知レコードを作成する
    @post.save_notification_comment!(current_user, comment.id)
  end

  def destroy
    PostComment.find(params[:id]).destroy
    # redirect_to post_path(params[:post_id]) ←非同期通信のため削除
    @post = Post.find(params[:post_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
