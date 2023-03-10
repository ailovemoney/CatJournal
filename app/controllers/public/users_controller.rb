# frozen_string_literal: true

class Public::UsersController < ApplicationController

  def create
  end

  def show
    @user = current_user
    @post = Post.new
  end

  def edit
  end

  def update
  end

end
