# frozen_string_literal: true

require "rails_helper"

describe PostInterestedUsersController, type: :controller do
  describe "#destroy" do
    it "validates user" do
      user = create(:user)
      post_owner = create(:user)
      post = create(:post, user: post_owner)
      post.interested_users << user

      sign_in_as(post_owner)
      post(
        :destroy,
        params: {
          post_id: post.id,
          id: user.id
        }
      )

      expect(response.status).to eq 404
      expect(post.interested_users.count).to eq 1
    end
  end
end
