# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :require_login

  def show
    @posts = Post.active.by_date.page(params[:page]).per(10)
  end
end
