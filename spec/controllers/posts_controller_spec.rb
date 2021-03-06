# frozen_string_literal: true

require "rails_helper"

describe PostsController do
  describe "#create" do
    it "renders post on success" do
      user = create(:user)
      sign_in_as(user)

      post(
        :create,
        params: {
          post: {
            game: "Catan",
            game_type: "board game",
            description: "Hello there!",
            players_needed: 3,
            skill_level: "beginner",
            city: "Belgrade",
            date: 5.days.from_now.to_date
          }
        }
      )

      expect(user.posts.count).to eq 1
      post = user.posts.first
      expect(post).to have_attributes(
        game: "Catan",
        game_type: "board game",
        description: "Hello there!",
        players_needed: 3,
        skill_level: "beginner",
        city: "Belgrade",
        date: 5.days.from_now.to_date
      )
      expect(response).to redirect_to edit_post_path(post)
    end
  end
end
