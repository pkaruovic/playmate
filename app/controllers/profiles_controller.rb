# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :require_login
  before_action :validate_user, only: [:edit, :update]
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:note] = "Profile updated"
      redirect_to profile_path(@user)
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :biography, :birth_date)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def validate_user
    user = User.find(params[:id])
    if user != current_user
      not_found
    end
  end
end

