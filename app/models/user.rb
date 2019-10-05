# frozen_string_literal: true

class User < ApplicationRecord
  include Clearance::User

  has_many :posts, dependent: :destroy
  has_and_belongs_to_many :interesting_posts, class_name: 'Post'

  enum genders: { male: "male", female: "female" }

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 25 }

  def display_name
    "#{first_name} #{last_name}"
  end
end
