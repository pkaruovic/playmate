# frozen_string_literal: true

class UsersController < Clearance::UsersController

  private

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)
    name = user_params.delete(:name)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
      user.name = name
    end
  end
end
