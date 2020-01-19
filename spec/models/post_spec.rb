# frozen_string_literal: true

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

  describe ".search" do
    it "returns all posts when query is empty" do
      first_post = create(:post, description: "Hello there!")
      second_post = create(:post, description: "Hola mundo!")

      expect(described_class.search(query: "")).to match_array [first_post, second_post]
    end

    it "returns posts which contain given text in description" do
      first_post = create(:post, description: "Hello there!")
      second_post = create(:post, description: "Hola mundo!")

      expect(described_class.search(query: "hello")).to eq [first_post]
    end

    it "returns posts which contain given text in city name" do
      first_post = create(:post, city: "Belgrade")
      second_post = create(:post, city: "Vlasotince")

      expect(described_class.search(query: "vla")).to eq [second_post]
    end

    it "returns posts which contain given text in game name" do
      first_post = create(:post, game: "Gloomhaven")
      second_post = create(:post, game: "Catan")

      expect(described_class.search(query: "haven")).to eq [first_post]
    end

    it "returns posts for given game type" do
      board_game_post = create(:post, game_type: "board game")
      sport_post = create(:post, game_type: "sport")

      expect(described_class.search(game_type: "board game")).to eq [board_game_post]
      expect(described_class.search(game_type: "sport")).to eq [sport_post]
    end

    it "returns posts in given date range" do
      november_post = create(:post, date: Date.new(2020, 11, 1))
      december_post = create(:post, date: Date.new(2020, 12, 1))

      expect(described_class.search(date_from: Date.new(2020, 11, 1))).to eq [november_post, december_post]
      expect(described_class.search(date_from: Date.new(2020, 11, 2))).to eq [december_post]
      expect(described_class.search(date_to: Date.new(2020, 12, 1))).to eq [november_post, december_post]
      expect(described_class.search(date_to: Date.new(2020, 11, 30))).to eq [november_post]
      expect(described_class.search(date_from: Date.new(2020, 10, 1), date_to: Date.new(2020, 11, 1))).to eq [november_post]
    end

    it "returns archived posts" do
      archived_post = create(:post, archived: true)
      active_post = create(:post, archived: false)

      expect(described_class.search(archived: true)).to eq [archived_post]
    end

    it "returns active posts" do
      archived_post = create(:post, archived: true)
      active_post = create(:post, archived: false)

      expect(described_class.search(archived: false)).to eq [active_post]
    end
  end

  describe "#players_found?" do
    it "is true when there are as many accepted join requests as there are players needed" do
      post = create(:post, players_needed: 1)
      join_request = create(:join_request, post: post)

      expect(post.players_found?).to be false

      join_request.update(status: :accepted)

      expect(post.players_found?).to be true
    end
  end
end
