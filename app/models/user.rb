# frozen_string_literal: true

class User < ApplicationRecord
  include Clearance::User

  has_many :posts, dependent: :destroy
  has_and_belongs_to_many :interesting_posts, class_name: "Post"
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  enum genders: { male: "male", female: "female" }

  validates :name, presence: true, length: { minimum: 2, maximum: 70 }
  validate :validate_birth_date, unless: ->{ birth_date.nil? }

  private

  def validate_birth_date
    if birth_date.year < 1920 || birth_date >= Date.today
      errors.add(:birth_date, "is invalid")
    end
  end
end
