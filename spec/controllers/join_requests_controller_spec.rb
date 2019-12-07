# frozen_string_literal: true

require "rails_helper"

describe JoinRequestsController, type: :controller do
  describe "#create" do
    it "creates join request and notifies post owner" do
      user = create(:user, name: "Mila Kunis")
      post_owner = create(:user)
      subject = create(:post, user: post_owner)
      sign_in_as(user)

      expect{
        post(:create, params: { post_id: subject.id }, format: :js)
      }.to have_broadcasted_to(post_owner)
        .from_channel(NotificationsChannel)
        .with(unseen_notifications_count: 1)

      expect(response.status).to eq 200
      expect(subject.join_requests.count).to eq 1
      expect(subject.join_requests.first).to have_attributes(
        user: user,
        status: "pending"
      )
      expect(post_owner.notifications.count).to eq 1
      expect(post_owner.notifications.first).to have_attributes(
        actor: user,
        text: "*#{user.name}* is interested in your *post*",
        action_path: post_path(subject)
      )
    end
  end

  describe "#update" do
    it "notifies user when join request is accepted" do
      user = create(:user, name: "Darth Vader")
      applicant = create(:user)
      subject = create(:post, user: user)
      join_request = create(:join_request, post: subject, user: applicant, status: "pending")
      sign_in_as(user)

      expect{
        patch(
          :update,
          params: {
            post_id: subject.id,
            id: join_request.id,
            join_request: {
              status: "accepted"
            }
          },
          format: :js
        )
      }.to have_broadcasted_to(applicant)
        .from_channel(NotificationsChannel)
        .with(unseen_notifications_count: 1)

      expect(response.status).to eq 200
      expect(join_request.reload).to be_accepted
      expect(applicant.notifications.count).to eq 1
      expect(applicant.notifications.first).to have_attributes(
        actor: user,
        text: "*#{user.name}* accepted you for a *game*",
        action_path: post_path(subject)
      )
    end

    it "does not notify user when post is reverted to pending" do
      user = create(:user, name: "Darth Vader")
      applicant = create(:user)
      subject = create(:post, user: user)
      join_request = create(:join_request, post: subject, user: applicant, status: "accepted")
      sign_in_as(user)

      expect{
        patch(
          :update,
          params: {
            post_id: subject.id,
            id: join_request.id,
            join_request: {
              status: "pending"
            }
          },
          format: :js
        )
      }.not_to have_broadcasted_to(applicant)
        .from_channel(NotificationsChannel)

      expect(response.status).to eq 200
      expect(join_request.reload).to be_pending
      expect(applicant.notifications.count).to eq 0
    end
  end

  describe "#destroy" do
    it "destroys join request and notifies post owner" do
      user = create(:user, name: "Mila Kunis")
      post_owner = create(:user)
      subject = create(:post, user: post_owner)
      join_request = create(:join_request, post: subject, user: user)
      sign_in_as(user)

      expect{
        delete(
          :destroy,
          params: { post_id: subject.id, id: join_request.id },
          format: :js
        )
      }.to have_broadcasted_to(post_owner)
        .from_channel(NotificationsChannel)
        .with(unseen_notifications_count: 1)

      expect(response.status).to eq 200
      expect(subject.join_requests.count).to eq 0
      expect(post_owner.notifications.count).to eq 1
      expect(post_owner.notifications.first).to have_attributes(
        actor: user,
        text: "*#{user.name}* is no longer interested in your *post*",
        action_path: post_path(subject)
      )
    end

    it "validates user" do
      user = create(:user)
      post_owner = create(:user)
      subject = create(:post, user: post_owner)
      join_request = create(:join_request, post: subject, user: user)

      sign_in_as(post_owner)
      post(
        :destroy,
        params: {
          post_id: subject.id,
          id: join_request.id
        }
      )

      expect(response.status).to eq 404
      expect(subject.join_requests.count).to eq 1
    end
  end
end
