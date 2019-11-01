# frozen_string_literal: true

require "rails_helper"

describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_least(2).is_at_most(70) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:posts).dependent(:destroy) }

  describe "#display_name" do
    it "is name" do
      user = create(:user, name: "Igor Pantovic")

      expect(user.display_name).to eq "Igor Pantovic"
    end
  end
end
