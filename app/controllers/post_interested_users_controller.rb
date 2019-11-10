# frozen_string_literal: true

class PostInterestedUsersController < ApplicationController
  before_action :require_login
  before_action :validate_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @post.interested_users << current_user
    UserMailer.with(user: @post.user, post: @post, playmate: current_user)
      .potential_playmate_email
      .deliver_later
    respond_to :js
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.interested_users.delete(params[:id])
    respond_to :js
  end

  private

  def validate_user
    if current_user.id != params[:id].to_i
      not_found
    end
  end
end
