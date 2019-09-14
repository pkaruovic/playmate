# frozen_string_literal: true

require "rails_helper"

feature "user signs in" do
  it "with valid params" do
    first_name = "John"
    last_name = "Doe"
    email = "user@example.com"
    password = "password"
    create(:user, first_name: first_name, last_name: last_name, email: email, password: password)

    visit sign_in_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Sign in"

    expect(page).to have_content "#{first_name} #{last_name}"
  end
end
