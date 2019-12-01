
# frozen_string_literal: true

require "rails_helper"

feature "user is interested in post" do
  scenario "post owner is notified", js: true do
    user = create(:user)
    post_owner = create(:user, email: "post@owner.io")
    post = create(:post, user: post_owner)

    visit root_path(as: user)
    within "[data-test=post-#{post.id}]" do
      find("[data-test=add_join_request_btn]").click
    end

    within("[data-test=post-#{post.id}]") { expect(page).to have_selector(:css, "[data-test=remove_join_request_btn]") }
  end
end

feature "user is no longer interested in post", js: true do
  scenario "he deletes join request" do
    user = create(:user)
    post = create(:post)
    create(:join_request, post: post, user: user)

    visit root_path(as: user)
    within "[data-test=post-#{post.id}]" do
      find("[data-test=remove_join_request_btn]").click
    end

    within("[data-test=post-#{post.id}]") { expect(page).to have_selector(:css, "[data-test=add_join_request_btn]") }
  end
end
