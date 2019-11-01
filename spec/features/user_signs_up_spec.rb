# frozen_string_literal: true

require "rails_helper"

feature "user signs up" do
  it "with valid params" do
    visit sign_up_path

    fill_in "Name", with: "John Doe"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    click_button "Sign up"

    expect(page).to have_current_path(root_path)
  end

  it "shows errors for invalid fields" do
    visit sign_up_path

    fill_in "Name", with: "John Doe"
    click_button "Sign up"

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
