# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.notifications
      .includes(:actor)
      .order(created_at: :desc)
      .page(params[:page]).per(10)

    respond_to :js
  end

  def mark_as_read
    @notifications = current_user.notifications.find(params[:ids])
    ActiveRecord::Base.transaction do
      @notifications.each do |n|
        n.update!(seen: true)
      end
    end

    respond_to :js
  end
end
