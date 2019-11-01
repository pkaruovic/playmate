# frozen_string_literal: true

require "rails_helper"

feature "user updates personal data" do
  scenario "successfully" do
    user = create(:user, name: "John Doe")

    visit edit_profile_path(user, as: user)
    fill_in "Name", with: "Mila Kunis"
    fill_in "Birth date", with: "14-9-1983"
    select "female", from: "Gender"
    fill_in "Biography", with: "I'm young movie star."
    click_button "Save"

    visit profile_path(user, as: user)
    within "#personal-data" do
      expect(page).to have_content "Mila Kunis"
      expect(page).to have_content "14 Sep, 1983"
      expect(page).to have_content "female"
      expect(page).to have_content "I'm young movie star."
    end
  end

  scenario "fails if it is another user" do
    user = create(:user)
    hackerman = create(:user)

    visit edit_profile_path(user, as: hackerman)

    expect(page).to have_content /doesn't exist/i
  end
end
