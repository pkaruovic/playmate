# frozen_string_literal: true

require "rails_helper"

feature "user signs in" do
  it "with valid params" do
    email = "user@example.com"
    password = "password"
    create(:user, first_name: "John", last_name: "Doe", email: email, password: password)

    visit sign_in_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"

    expect(page).to have_current_path(root_path)
  end
end
