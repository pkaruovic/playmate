# frozen_string_literal: true

require "rails_helper"

describe JoinRequest, type: :model do
  it "validates number of accepted join requests for post" do
    post = create(:post, players_needed: 1)
    accepted_join_request = create(:join_request, post: post, status: "accepted")
    new_join_request = create(:join_request, post: post, status: "pending")

    new_join_request.status = "accepted"

    expect(new_join_request).not_to be_valid
    expect(new_join_request.errors.full_messages).to include /the maximum number of accepted join requests has already been reached/i
  end
end
