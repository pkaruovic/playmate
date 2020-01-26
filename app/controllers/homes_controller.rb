# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :require_login
  before_action :set_search_params, only: [:show, :search]

  def show
    @posts = Post.includes(:user).available.by_date.page(params[:page]).per(10)
  end

  def search
    @posts = Post.includes(:user).available
    @posts = @posts.search(search_params) unless search_params.empty?
    @posts = @posts.by_date.page(params[:page]).per(10)

    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  private

  def set_search_params
    @search_params = search_params
  end

  def search_params
    params.permit(:query, :game_type, :date_from, :date_to).to_h.symbolize_keys
  end
end
