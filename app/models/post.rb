# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :join_requests, dependent: :destroy
  has_many :interested_users, through: :join_requests, source: :user

  enum skill_level: {
    beginner: "beginner",
    intermediate: "intermediate",
    advanced: "advanced"
  }
  enum game_type: {
    "board game" => "board game",
    "sport" => "sport"
  }

  validates :description, presence: true, length: { maximum: 250 }
  validates :city, :date, :game, :game_type, :players_needed, presence: true

  scope :by_date, ->{ order(created_at: :desc) }
  scope :active, ->{ where("date >= ?", Date.today).where(archived: false) }

  def belongs_to?(user)
    self.user.id == user.id
  end
end
