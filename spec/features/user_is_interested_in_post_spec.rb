
# frozen_string_literal: true

require "rails_helper"

feature "user is interested in post" do
  scenario "post owner is notified", js: true do
    user = create(:user)
    post_owner = create(:user, email: "post@owner.io")
    post = create(:post, user: post_owner)

    visit root_path(as: user)
    within "[data-test=post-#{post.id}]" do
      find("[data-test=add_interested_user_btn]").click
    end

    within("[data-test=post-#{post.id}]") { expect(page).to have_selector(:css, "[data-test=remove_interested_user_btn]") }
    expect_email_to_be_delivered(to: post_owner.email, subject: "Someone is interested in your post")
  end

  def expect_email_to_be_delivered(to:, subject:)
    expect(ActionMailer::Base.deliveries).not_to be_empty
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to include to
    expect(email.subject).to eq subject
  end
end

feature "user is no longer interested in post", js: true do
  scenario "he removes himself from post's interested users" do
    user = create(:user)
    post = create(:post)
    post.interested_users << user

    visit root_path(as: user)
    within "[data-test=post-#{post.id}]" do
      find("[data-test=remove_interested_user_btn]").click
    end

    within("[data-test=post-#{post.id}]") { expect(page).to have_selector(:css, "[data-test=add_interested_user_btn]") }
  end
end
