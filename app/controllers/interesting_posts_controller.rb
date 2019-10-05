# frozen_string_literal: true

class InterestingPostsController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(interesting_post_params.fetch(:post_id))
    current_user.interesting_posts << @post
    UserMailer.with(user: @post.user, post: @post, playmate: current_user).potential_playmate_email.deliver_later
    respond_to do |format|
      format.js
    end
  end

  private

  def interesting_post_params
    params.require(:data).permit(:post_id)
  end
end
