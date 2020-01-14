# frozen_string_literal: true

require "rails_helper"

feature "user searches for post", type: :feature do
  context "on home page" do
    scenario "by text", js: true do
      user = create(:user)
      first_post = create(:post, description: "Hello there!", archived: false)
      second_post = create(:post, description: "Hola mundo!", archived: false)
      outdated_post = create(:post, description: "Hello, I'm old", date: 5.days.ago, archived: false)
      archived_post = create(:post, description: "Hello, I'm archived", archived: true)

      visit root_path(as: user)
      fill_in "query", with: "hello"

      expect(page).not_to have_post second_post
      expect(page).not_to have_post outdated_post
      expect(page).not_to have_post archived_post
      # if we set this expectation as first it may be false positive
      # because first post already exists on the page and search ajax may not be resolved yet
      expect(page).to have_post first_post
    end

    scenario "by game type", js: true do
      user = create(:user)
      first_post = create(:post, game_type: "board game", archived: false)
      second_post = create(:post, game_type: "sport", archived: false)
      outdated_post = create(:post, game_type: "board game", date: 5.days.ago, archived: false)
      archived_post = create(:post, game_type: "board game", archived: true)

      visit root_path(as: user)
      select "Board game", from: "game_type", visible: false

      expect(page).not_to have_post second_post
      expect(page).not_to have_post outdated_post
      expect(page).not_to have_post archived_post
      # if we set this expectation as first it may be false positive
      # because first post already exists on the page and search ajax may not be resolved yet
      expect(page).to have_post first_post
    end

    scenario "by date", js: true do
      user = create(:user)
      first_post = create(:post, date: next_month_date(18), archived: false)
      second_post = create(:post, date: next_month_date(20), archived: false)
      archived_post = create(:post, date: next_month_date(20), archived: true)

      visit root_path(as: user)
      open_date_picker
      open_next_month
      select_date_range "19", "21"

      expect(page).not_to have_post first_post
      expect(page).not_to have_post archived_post
      expect(page).to have_post second_post
    end

  end

  context "on posts page" do
    scenario "by text", js: true do
      user = create(:user)
      first_post = create(:post, user: user, description: "Hello there!", archived: false)
      second_post = create(:post, user: user, description: "Hola mundo!", archived: false)
      outdated_post = create(:post, user: user, description: "Hello, I'm old", date: 5.days.ago, archived: false)
      archived_post = create(:post, user: user, description: "Hello, I'm archived", archived: true)
      another_user_post = create(:post, description: "Hello, i belong to another user!", archived: false)

      visit posts_path(as: user)
      select "Active", from: "archived", visible: false
      fill_in "query", with: "hello"

      expect(page).not_to have_post another_user_post
      expect(page).not_to have_post second_post
      expect(page).not_to have_post archived_post
      # if we set this expectation as first it may be false positive
      # because first post already exists on the page and search ajax may not be resolved yet
      expect(page).to have_post first_post
      expect(page).to have_post outdated_post
    end

    scenario "by archived status", js: true do
      user = create(:user)
      archived_post = create(:post, user: user, archived: true)
      active_post = create(:post, user: user, archived: false)

      visit posts_path(as: user)
      select "Archived", from: "archived", visible: false

      expect(page).not_to have_post active_post
      expect(page).to have_post archived_post

      select "Active", from: "archived", visible: false

      expect(page).not_to have_post archived_post
      expect(page).to have_post active_post
    end
  end

  def open_date_picker
    find("[data-provide=date_range_picker]").click
    find(".flatpickr-calendar", visible: true)
  end

  def open_next_month
    within ".flatpickr-month" do
      find(".flatpickr-next-month").click
    end
  end

  def select_date_range(first_date, second_date)
    within ".flatpickr-days" do
      find("span", text: first_date).click
      find("span", text: second_date).click
    end
    find(".flatpickr-calendar", visible: :hidden)
  end

  def next_month_date(day)
    today = Date.today
    Date.new(today.year, today.month + 1, day)
  end

  def have_post(post)
    have_selector "#post-#{post.id}"
  end
end
