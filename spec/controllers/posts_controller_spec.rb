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
            description: "Hello there!",
            skill_level: "beginner",
            city: "Belgrade",
            date: 5.days.from_now.to_date
          }
        }
      )

      expect(user.posts.count).to eq 1
      post = user.posts.first
      expect(post).to have_attributes(
        description: "Hello there!",
        skill_level: "beginner",
        city: "Belgrade",
        date: 5.days.from_now.to_date
      )
      expect(response).to redirect_to post
    end
  end
end
