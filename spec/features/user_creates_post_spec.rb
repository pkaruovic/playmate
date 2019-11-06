# frozen_string_literal: true

require "rails_helper"

feature "user creates a post" do
  scenario "post is shown on home page" do
    user = create(:user, name: "Mila Kunis")
    date = 5.days.from_now.to_date
    post_description = "One Catan player needed"

    visit new_post_path(as: user)
    fill_in "Game", with: "Catan"
    select "board game", from: "Game type"
    fill_in "City", with: "Belgrade"
    fill_in "Date", with: date.iso8601
    fill_in "Players needed", with: 3
    select "intermediate", from: "Skill level"
    fill_in "Description", with: post_description
    click_button "Create"
    visit root_path

    post = user.posts.first!
    within "[data-test=post-#{post.id}]" do
      expect(page).to have_css("[data-test=post_owner]", text: user.name)
      expect(page).to have_css("[data-test=post_description]", text: post_description)
      expect(page).to have_css("[data-test=post_game]", text: "Catan")
      expect(page).to have_css("[data-test=post_city]", text: "Belgrade")
      expect(page).to have_css("[data-test=post_skill_level]", text: "intermediate")
      expect(page).to have_css("[data-test=post_date]", text: date.strftime("%-e.%-m.%y"))
      expect(page).to have_css("[data-test=post_players_needed]", text: 3)
    end
  end
end
