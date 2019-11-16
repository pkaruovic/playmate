# frozen_string_literal: true

class PostInterestedUsersController < ApplicationController
  before_action :require_login
  before_action :validate_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @post.interested_users << current_user
    notify_post_owner
    respond_to :js
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.interested_users.delete(params[:id])
    respond_to :js
  end

  private

  def notify_post_owner
    notification = Notification.create!(
      recipient: @post.user,
      actor: current_user,
      text: "*#{current_user.name}* is interested in your *post*",
      action_path: post_path(@post)
    )
    NotificationsChannel.broadcast_to(
      notification.recipient,
      unseen_notifications_count: notification.recipient.notifications.unseen.count
    )
    UserMailer.with(user: @post.user, post: @post, playmate: current_user)
      .potential_playmate_email
      .deliver_later
  end

  def validate_user
    if current_user.id != params[:id].to_i
      not_found
    end
  end
end
