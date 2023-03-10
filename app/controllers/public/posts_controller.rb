class Public::PostsController < ApplicationController
  
  def index
    @post = Post.new
    @posts = Post.all
  end
  
  def create
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
end
