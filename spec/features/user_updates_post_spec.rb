# frozen_string_literal: true

require "rails_helper"

feature "user updates post" do
  scenario "with valid attributes" do
    user = create(:user)
    post = create(:post, user: user)
    date = 3.days.from_now.to_date.strftime("%e %B, %Y")

    visit edit_post_path(post, as: user)
    fill_in "Game", with: "Catan"
    select "board game", from: "Game type"
    fill_in "City", with: "Belgrade"
    fill_in "Date", with: date
    fill_in "Players needed", with: 3
    select "beginner", from: "Skill level"
    fill_in "Description", with: "Hello there!"
    click_button "Save"

    visit edit_post_path(post, as: user)
    expect(page).to have_field "Game", with: "Catan"
    expect(page).to have_field "Game type", with: "board game"
    expect(page).to have_field "City", with: "Belgrade"
    expect(page).to have_field "Date", with: date
    expect(page).to have_field "Players needed", with: "3"
    expect(page).to have_field "Skill level", with: "beginner"
    expect(page).to have_field "Description", with: "Hello there!"
  end
end
