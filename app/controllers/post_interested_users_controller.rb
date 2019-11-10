# frozen_string_literal: true

class PostInterestedUsersController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @post.interested_users << current_user
    UserMailer.with(user: @post.user, post: @post, playmate: current_user)
      .potential_playmate_email
      .deliver_later
    respond_to do |format|
      format.js
    end
  end
end
