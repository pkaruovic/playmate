# frozen_string_literal: true

class UsersController < Clearance::UsersController
  before_action :require_login, only: [:show, :edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(filtered_user_params)
      flash[:note] = "Data successfully updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def filtered_user_params
    user_params.except(:password)
  end

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :gender, :biography, :birth_date)
  end

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    first_name = user_params.delete(:first_name)
    last_name = user_params.delete(:last_name)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.first_name = first_name
      user.last_name = last_name
    end
  end
end
