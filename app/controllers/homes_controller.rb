# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :require_login

  def index
    @posts = Post.all
  end
end
