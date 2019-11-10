# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :require_login
  before_action :validate_user, only: [:edit, :update]
  before_action :set_user

  def show
  end

  def edit
    @user_profile = UserProfile.new(@user)
  end

  def update
    @user_profile = UserProfile.new(@user)
    if @user_profile.update(profile_params)
      flash[:note] = "Profile updated"
      redirect_to profile_path(@user)
    else
      render "edit"
    end
  end

  private

  def profile_params
    params.require(:user_profile).permit(:name, :email, :biography, :day_of_birth, :month_of_birth, :year_of_birth)
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

