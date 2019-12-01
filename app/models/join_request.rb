# frozen_string_literal: true

class JoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :status, inclusion: { in: %w[pending accepted] }
end
