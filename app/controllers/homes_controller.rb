# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :require_login

  def index
    @posts = Post.by_date
  end
end
