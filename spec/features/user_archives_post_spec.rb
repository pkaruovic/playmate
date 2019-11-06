# frozen_string_literal: true

require "rails_helper"

feature "User archives post" do
  scenario "post is not shown on home page anymore" do
    user = create(:user)
    post = create(:post, user: user, description: "Testing post archive")

    visit post_path(post, as: user)
    click_button "Archive"
    visit root_path

    expect(page).not_to have_content "Testing post archive"
  end
end

feature "User restores archived post" do
  scenario "post is shown on home page" do
    user = create(:user)
    post = create(:post, user: user, description: "Testing post restore", archived: true)

    visit post_path(post, as: user)
    click_button "Restore"
    visit root_path

    expect(page).to have_content "Testing post restore"
  end
end
