# frozen_string_literal: true

class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :post, touch: true

  enum status: { pending: "pending", accepted: "accepted" }

  validate :validate_number_of_accepted_join_requests

  private

  def validate_number_of_accepted_join_requests
    if post.players_found? && status_changed?(from: "pending", to: "accepted")
      errors.add(:base, "The maximum number of accepted join requests has already been reached")
    end
  end
end
