# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user

  enum skill_level: {
    beginner: "beginner",
    intermediate: "intermediate",
    advanced: "advanced"
  }

  validates :description, presence: true, length: { maximum: 250 }
  validates :city, :date, presence: true

  scope :by_date, ->{ order(created_at: :desc) }
  scope :active, ->{ where(archived: false) }

  def belongs_to?(user)
    self.user.id == user.id
  end
end
