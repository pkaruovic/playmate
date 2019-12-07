# frozen_string_literal: true

class JoinRequestsController < ApplicationController
  before_action :require_login

  def create
    @post = Post.find(params[:post_id])
    @join_request = @post.join_requests.create(user: current_user)
    send_notification(
      recipient: @post.user,
      actor: current_user,
      text:"*#{current_user.name}* is interested in your *post*"
    )

    respond_to :js
  end

  def update
    @post = current_user.posts.find(params[:post_id])
    @join_request = @post.join_requests.find(params[:id])
    if @join_request.update(join_request_params)
      if @join_request.accepted?
        send_notification(
          recipient: @join_request.user,
          actor: current_user,
          text:"*#{current_user.name}* accepted you for a *game*"
        )
      end
    end

    respond_to :js
  end

  def destroy
    @post = Post.find(params[:post_id])
    @join_request = @post.join_requests.find(params[:id])
    not_found unless @join_request.user == current_user

    @join_request.destroy
    send_notification(
      recipient: @post.user,
      actor: current_user,
      text:"*#{current_user.name}* is no longer interested in your *post*"
    )

    respond_to :js
  end

  private

  def join_request_params
    params.require(:join_request).permit(:status)
  end

  def send_notification(recipient:, actor:, text:)
    notification = Notification.create!(
      recipient: recipient,
      actor: actor,
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
