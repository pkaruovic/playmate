# frozen_string_literal: true

require "rails_helper"

feature "user updates personal data" do
  scenario "successfully" do
    user = create(:user, name: "John Doe")

    visit edit_profile_path(user, as: user)
    fill_in "Name", with: "Mila Kunis"
    fill_in "Email", with: "mila.kunis@gmail.com"
    select "September", from: "user_profile[month_of_birth]"
    fill_in "user_profile[day_of_birth]", with: 14
    fill_in "user_profile[year_of_birth]", with: 1983
    fill_in "Biography", with: "I'm young movie star."
    click_button "Save"

    visit profile_path(user, as: user)
    within "#personal-data" do
      expect(page).to have_content "Mila Kunis"
      expect(page).to have_content "14 Sep, 1983"
      expect(page).to have_content "I'm young movie star."
    end
  end

  scenario "validation errors are shown" do
    user = create(:user)

    visit edit_profile_path(user, as: user)
    fill_in "Email", with: nil
    select "", from: "user_profile[month_of_birth]"
    fill_in "user_profile[day_of_birth]", with: 12
    fill_in "user_profile[year_of_birth]", with: 1992
    click_button "Save"

    expect(page).to have_content "Email is invalid"
    expect(page).to have_content "Birth date is invalid"
  end

  scenario "fails if it is another user" do
    user = create(:user)
    hackerman = create(:user)

    visit edit_profile_path(user, as: hackerman)

    expect(page).to have_content /doesn't exist/i
  end
end
