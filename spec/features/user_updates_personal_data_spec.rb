# frozen_string_literal: true

require "rails_helper"

feature "user updates personal data" do
  scenario "successfully" do
    user = create(:user, first_name: "John", last_name: "Doe")

    visit edit_user_path(user, as: user)
    fill_in "First name", with: "Mila"
    fill_in "Last name", with: "Kunis"
    fill_in "Birth date", with: "14-9-1983"
    select "female", from: "Gender"
    fill_in "Biography", with: "I'm young movie star."
    click_button "Save"

    visit user_path(user, as: user)
    within "#personal-data" do
      expect(page).to have_content "Mila Kunis"
      expect(page).to have_content "14 Sep, 1983"
      expect(page).to have_content "female"
      expect(page).to have_content "I'm young movie star."
    end
  end
end
