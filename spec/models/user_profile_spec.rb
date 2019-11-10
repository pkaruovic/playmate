# frozen_string_literal: true

require "rails_helper"

describe UserProfile do
  it "exposes user data" do
    user = build(
      :user,
      name: "John Doe",
      email: "user@example.com",
      birth_date: Date.new(1992, 11, 11),
      biography: "Hello there!"
    )
    user_profile = described_class.new(user)

    expect(user_profile).to have_attributes(
      name: user.name,
      email: user.email,
      biography: user.biography,
      day_of_birth: user.birth_date.day,
      month_of_birth: user.birth_date.month,
      year_of_birth: user.birth_date.year
    )
  end

  describe "#update" do
    it "updates the user" do
      user = build(
        :user,
        name: "John Doe",
        email: "user@example.com",
        birth_date: Date.new(2000, 1, 1),
        biography: "Hello there!"
      )
      user_profile = described_class.new(user)
      params = {
        name: "Mila Kunis",
        email: "mila.kunis@gmail.com",
        day_of_birth: 10,
        month_of_birth: 11,
        year_of_birth: 2000,
        biography: "Test biography"
      }

      expect(user_profile.update(params)).to be true
      expect(user).to have_attributes(
        name: "Mila Kunis",
        email: "mila.kunis@gmail.com",
        birth_date: Date.new(2000, 11, 10),
        biography: "Test biography"
      )
    end

    describe "birth date" do
      it "updates one of the birth date fields" do
        user = build(:user, birth_date: Date.new(1992, 11, 11))
        user_profile = described_class.new(user)

        expect(user_profile.update(day_of_birth: 12)).to be true
        expect(user.birth_date).to eq Date.new(1992, 11, 12)
      end

      it "accepts string values for birth date fields" do
        user = build(:user, birth_date: Date.new(1992, 11, 11))
        user_profile = described_class.new(user)

        expect(user_profile.update(day_of_birth: "12")).to be true
        expect(user.birth_date).to eq Date.new(1992, 11, 12)
      end

      it "sets birth date to nil" do
        user = build(:user, birth_date: Date.new(1992, 11, 11))
        user_profile = described_class.new(user)

        expect(user_profile.update(day_of_birth: nil, month_of_birth: nil, year_of_birth: nil)).to be true
        expect(user.birth_date).to be nil
      end
    end
  end

  it "inherits user validation errors" do
    user = build(:user)
    user_profile = described_class.new(user)

    expect(user_profile.update(email: nil)).to be false
    expect(user_profile.valid?).to be false
    expect(user_profile.errors[:email]).not_to be_empty
  end

  it "validates birth date" do
    user = build(:user)
    user_profile = described_class.new(user)
    params = {
      day_of_birth: 33, # invalid date
      month_of_birth: 10,
      year_of_birth: 2000
    }

    expect(user_profile.update(params)).to be false
    expect(user_profile.valid?).to be false
    expect(user_profile.errors[:birth_date]).not_to be_empty

    params = {
      day_of_birth: nil,
      month_of_birth: 10,
      year_of_birth: 2000
    }

    expect(user_profile.update(params)).to be false
    expect(user_profile.valid?).to be false
    expect(user_profile.errors[:birth_date]).not_to be_empty
  end
end
