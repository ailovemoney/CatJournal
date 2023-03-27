class Public::FavoritesController < ApplicationController
  
  def create
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: @post.id)
    favorite.save
    # 通知機能。
    # いいねを押したタイミングで通知レコードを作成する。
    @post.create_notification_like!(current_user)
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: @post.id)
    favorite.destroy
  end
end
