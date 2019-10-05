# frozen_string_literal: true

require "rails_helper"

describe User, type: :model do
  it { should validate_presence_of(:first_name) }
  it { should validate_length_of(:first_name).is_at_least(2).is_at_most(25) }
  it { should validate_presence_of(:last_name) }
  it { should validate_length_of(:last_name).is_at_least(2).is_at_most(25) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:posts).dependent(:destroy) }

  describe "#display_name" do
    it "is first name and last name" do
      user = create(:user, first_name: "Igor", last_name: "Pantovic")

      expect(user.display_name).to eq "Igor Pantovic"
    end
  end
end
