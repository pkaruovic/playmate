# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_login

  def index
    @search_params = search_params
    @posts = current_user.posts.search(@search_params).by_date
      .page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @post = Post.find(params[:id])
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

  def search_params
    hash = params.permit(:archived, :query).to_h.symbolize_keys
    hash[:archived] = hash.fetch(:archived) do |key|
      hash.key?(key) ? hash[key] == "true" : false
    end

    hash
  end
end
