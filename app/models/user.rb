# frozen_string_literal: true

class User < ApplicationRecord
  include Clearance::User

  has_many :posts, dependent: :destroy
  has_and_belongs_to_many :interesting_posts, class_name: 'Post'

  enum genders: { male: "male", female: "female" }

  validates :name, presence: true, length: { minimum: 2, maximum: 70 }

  def display_name
    name
  end
end
