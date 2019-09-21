# frozen_string_literal: true

class User < ApplicationRecord
  include Clearance::User

  has_many :posts

  validates :first_name, :last_name, presence: true

  def display_name
    "#{first_name} #{last_name}"
  end
end
