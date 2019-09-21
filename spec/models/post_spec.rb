require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_most(250) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:date) }

  describe "#belongs_to" do
    it "checks if post belongs to user" do
      owner = create(:user)
      not_owner = create(:user)
      post = create(:post, user: owner)

      expect(post.belongs_to?(owner)).to be true
      expect(post.belongs_to?(not_owner)).to be false
    end
  end
end
