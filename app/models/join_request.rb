# frozen_string_literal: true

class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum status: { pending: "pending", accepted: "accepted" }
end
