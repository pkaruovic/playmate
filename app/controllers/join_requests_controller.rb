# frozen_string_literal: true

class JoinRequestsController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @post.join_requests.create(user: current_user)
    notify_post_owner("*#{current_user.name}* is interested in your *post*")

    respond_to :js
  end

  def destroy
    @post = Post.find(params[:post_id])
    @join_request = @post.join_requests.find(params[:id])
    not_found unless @join_request.user == current_user

    @join_request.destroy
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
end
