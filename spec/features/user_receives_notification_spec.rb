# frozen_string_literal: true

require "rails_helper"

feature "user receives notification" do
  scenario "notification is shown in the nav", js: true do
    user = create(:user)
    notification = create(
      :notification,
      recipient: user,
      actor: user,
      text: "Test notification",
      action_path: profile_path(user)
    )

    visit root_path(as: user)
    expect(page).to have_css(notification_indicator_selector, visible: true, text: 1)

    find(notifications_btn_selector).click
    expect(page).to have_css(notification_indicator_selector, visible: false, text: 0)
    within notification_list_selector do
      expect(page).to have_content notification.text
    end

    click_on notification.text
    expect(page).to have_current_path notification.action_path
  end

  feature "user opens notifications popover" do
    scenario "unseen notifications count is reduced", js: true do
      user = create(:user)
      create_list(:notification, 12, recipient: user)

      visit root_path(as: user)
      expect(page).to have_css(notification_indicator_selector, visible: true, text: 12)

      find(notifications_btn_selector).click
      expect(page).to have_css(notification_indicator_selector, visible: true, text: 2, exact_text: true)
    end
  end

  def notifications_btn_selector
    "[data-test=notifications_btn]"
  end

  def notification_list_selector
    "[data-test=notification_list]"
  end

  def notification_indicator_selector
    "[data-test=notification_indicator]"
  end
end

