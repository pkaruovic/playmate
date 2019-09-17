# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post
    else
      render "new"
    end
  end

  private

  def post_params
    params.require(:post).permit(:description, :city, :date, :skill_level)
  end
end
