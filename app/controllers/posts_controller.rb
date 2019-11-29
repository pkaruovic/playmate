# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login

  def index
    @posts = current_user.posts
      .includes(:interested_users).by_date
      .page(params[:page]).per(10)
  end

  def show
    @post = current_user.posts.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:note] = "Post successfully created"
      redirect_to edit_post_path(@post)
    else
      render "new"
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      flash[:note] = "Post successfully updated"
      redirect_to post_path(@post)
    else
      render "edit"
    end
  end

  private

  def post_params
    params.require(:post).permit(
      :game, :game_type, :description, :city, :date,
      :skill_level, :players_needed, :archived
    )
  end
end
