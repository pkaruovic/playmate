# frozen_string_literal: true

require "rails_helper"

describe PostInterestedUsersController, type: :controller do
  describe "#create" do
    it "adds user to interested users and notifies post owner" do
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
      expect(subject.interested_users).to eq [user]
      expect(post_owner.notifications.count).to eq 1
      expect(post_owner.notifications.first).to have_attributes(
        actor: user,
        text: "*#{user.name}* is interested in your *post*",
        action_path: post_path(subject)
      )
    end
  end

  describe "#destroy" do
    it "deletes user from interested users and notifies post owner" do
      user = create(:user, name: "Mila Kunis")
      post_owner = create(:user)
      subject = create(:post, user: post_owner)
      subject.interested_users << user
      sign_in_as(user)

      expect{
        delete(:destroy, params: { post_id: subject.id, id: user.id }, format: :js)
      }.to have_broadcasted_to(post_owner)
        .from_channel(NotificationsChannel)
        .with(unseen_notifications_count: 1)

      expect(response.status).to eq 200
      expect(subject.interested_users.count).to eq 0
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
      subject.interested_users << user

      sign_in_as(post_owner)
      post(
        :destroy,
        params: {
          post_id: subject.id,
          id: user.id
        }
      )

      expect(response.status).to eq 404
      expect(subject.interested_users.count).to eq 1
    end
  end
end
