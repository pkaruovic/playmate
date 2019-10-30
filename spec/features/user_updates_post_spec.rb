# frozen_string_literal: true

require "rails_helper"

feature "User updates post" do
  scenario "with valid attributes" do
    user = create(:user)
    post = create(:post, user: user)
    date = 3.days.from_now.to_date.iso8601

    visit edit_post_path(post, as: user)
    fill_in "Description", with: "Hello there!"
    fill_in "City", with: "Belgrade"
    fill_in "Date", with: date
    select "beginner", from: "Skill level"
    click_button "Save"

    expect(page).to have_field "Description", with: "Hello there!"
    expect(page).to have_field "City", with: "Belgrade"
    expect(page).to have_field "Date", with: date
    expect(page).to have_field "Skill level", with: "beginner"
  end
end
