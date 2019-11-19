# frozen_string_literal: true

class PostInterestedUsersController < ApplicationController
  before_action :require_login
  before_action :validate_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @post.interested_users << current_user
    notify_post_owner("*#{current_user.name}* is interested in your *post*")

    respond_to :js
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.interested_users.delete(params[:id])
    notify_post_owner("*#{current_user.name}* is no longer interested in your *post*")

    respond_to :js
  end

  private

  def notify_post_owner(text)
    notification = Notification.create!(
      recipient: @post.user,
      actor: current_user,
      text: text,
      action_path: post_path(@post)
    )
    broadcast_unseen_notifications_count(notification.recipient)
  end

  def broadcast_unseen_notifications_count(recipient)
    NotificationsChannel.broadcast_to(
      recipient,
      unseen_notifications_count: recipient.notifications.unseen.count
    )
  end

  def validate_user
    if current_user.id != params[:id].to_i
      not_found
    end
  end
end
