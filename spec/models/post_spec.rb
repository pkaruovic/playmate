require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_most(250) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:game) }
  it { should validate_presence_of(:game_type) }
  it { should validate_presence_of(:players_needed) }
  it { should have_many(:join_requests).dependent(:destroy) }

  describe "#belongs_to" do
    it "checks if post belongs to user" do
      owner = create(:user)
      not_owner = create(:user)
      post = create(:post, user: owner)

      expect(post.belongs_to?(owner)).to be true
      expect(post.belongs_to?(not_owner)).to be false
    end
  end

  describe "#players_missing" do
    it "is remainder of #players_needed and number of accepted join requests" do
      post = create(:post, players_needed: 3)
      create(:join_request, post: post, status: "accepted")
      create(:join_request, post: post, status: "pending")

      expect(post.players_missing).to eq 2
    end
  end
end
