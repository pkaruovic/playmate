# frozen_string_literal: true

class InterestedPostsController < ApplicationController
  before_action :require_login

  def index
    @posts = current_user.interested_posts.active
      .search(search_params).by_date
      .page(params[:page]).per(10)
    @search_params = search_params

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def search_params
    params.permit(:query, :game_type).to_h.symbolize_keys
  end
end
