# frozen_string_literal: true

require "rails_helper"

feature "user creates a post" do
  scenario "post is shown on home page" do
    user = create(:user)
    post_description = "One Catan player needed"

    visit new_post_path(as: user)
    fill_in "Description", with: post_description
    fill_in "City", with: "Belgrade"
    fill_in "Date", with: 5.days.from_now.to_date.iso8601
    click_button "Create"
    visit root_path

    expect(page).to have_content post_description
  end
end
