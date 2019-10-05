# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def potential_playmate_email
    @user = params[:user]
    @post = params[:post]
    @playmate = params[:playmate]
    mail(to: @user.email, subject: "Someone is interested in your post")
  end
end
