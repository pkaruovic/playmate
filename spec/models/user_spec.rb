# frozen_string_literal: true

require "rails_helper"

describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(2).is_at_most(70) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:posts).dependent(:destroy) }

  it "validates #birth_date" do
    user = described_class.new
    user.validate
    expect(user.errors[:birth_date]).to be_empty

    user.birth_date = Date.new(1919, 1, 1)
    user.validate
    expect(user.errors[:birth_date]).not_to be_empty

    user.birth_date = Date.new(1995, 1, 1)
    user.validate
    expect(user.errors[:birth_date]).to be_empty

    user.birth_date = Date.today
    user.validate
    expect(user.errors[:birth_date]).not_to be_empty
  end
end
