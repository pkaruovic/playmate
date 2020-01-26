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
  validates :city, :date, :game, :game_type, presence: true
  validates :players_needed, numericality: { greater_than: 0 }
  validate :players_needed_is_not_less_than_players_accepted

  scope :by_date, ->{ order(created_at: :desc) }
  scope :active, ->{ where(archived: false) }

  class << self
    def available
      joins("LEFT JOIN (" +
            JoinRequest.accepted.to_sql +
            ") join_requests ON posts.id = join_requests.post_id")
        .where("posts.date >= ?", Date.today)
        .where(archived: false)
        .group("posts.id")
        .having("COUNT(join_requests.id) < posts.players_needed")
    end

    def search(query: nil, game_type: nil, date_from: nil, date_to: nil, archived: nil)
      scoped = all
      if query.present?
        search_query = query.strip.downcase
        text_condition = <<~SQL
        lower(city) LIKE :text OR
        lower(game) LIKE :text OR
        lower(description) LIKE :text
        SQL
        scoped = scoped.where(text_condition, text: "%#{search_query}%")
      end
      scoped = scoped.where(game_type: game_type) if game_type.present?
      scoped = scoped.where("date >= ?", date_from) if date_from.present?
      scoped = scoped.where("date <= ?", date_to) if date_to.present?
      scoped = scoped.where("archived = ?", archived) unless archived.nil?

      scoped
    end
  end

  def belongs_to?(user)
    self.user.id == user.id
  end

  def players_missing
    players_needed - join_requests.accepted.size
  end

  def players_found?
    players_missing == 0
  end

  private

  def players_needed_is_not_less_than_players_accepted
    if players_needed.present? && players_needed < join_requests.accepted.size
      errors.add(:players_needed, :invalid, message: "cannot be less than the number of players accepted")
    end
  end
end
