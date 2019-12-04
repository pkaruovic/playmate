# frozen_string_literal: true

require "rails_helper"

describe "user accepts join request", type: :feature do
  scenario "number of players needed decreases", js: true do
    user = create(:user)
    applicant = create(:user)
    post = create(:post, user: user, players_needed: 3)
    join_request = create(:join_request, post: post, user: applicant, status: "pending")

    visit post_path(post, as: user)
    within join_request_selector(join_request) do
      click_on "Accept"
    end

    expect(page).to have_css("[data-test=post_players_needed]", text: 2)
    within join_request_selector(join_request) do
      expect(page).to have_content "Accepted"
    end
  end
end

feature "user reverts join request to pending" do
  scenario "number of players needed increases", js: true do
    user = create(:user)
    applicant = create(:user)
    post = create(:post, user: user, players_needed: 3)
    join_request = create(:join_request, post: post, user: applicant, status: "accepted")

    visit post_path(post, as: user)
    within join_request_selector(join_request) do
      click_on "Remove"
    end

    expect(page).to have_css("[data-test=post_players_needed]", text: 3)
    within join_request_selector(join_request) do
      expect(page).not_to have_content "Accepted"
    end
  end
end

def join_request_selector(join_request)
  "[data-test=join_requests] > [data-test=join_request_#{join_request.id}]"
end
