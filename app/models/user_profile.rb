# frozen_string_literal: true

class UserProfile
  include ActiveModel::Model

  attr_reader :user
  attr_accessor :day_of_birth, :month_of_birth, :year_of_birth

  delegate :name, :email, :biography, to: :user

  validate :validate_birth_date_is_real_date
  validate :validate_user_is_valid

  def initialize(user)
    @user = user
    @day_of_birth = user.birth_date&.day
    @month_of_birth = user.birth_date&.month
    @year_of_birth = user.birth_date&.year
  end

  def update(params)
    params = process_params(params)
    user.assign_attributes(params)

    if valid?
      user.save
    else
      false
    end
  end

  private

  def process_params(params)
    self.day_of_birth = cast_to_number(params.delete(:day_of_birth)) if params.key?(:day_of_birth)
    self.month_of_birth = cast_to_number(params.delete(:month_of_birth)) if params.key?(:month_of_birth)
    self.year_of_birth = cast_to_number(params.delete(:year_of_birth)) if params.key?(:year_of_birth)

    if day_of_birth.present? && month_of_birth.present? && year_of_birth.present?
      begin
        params[:birth_date] = Date.new(
          year_of_birth,
          month_of_birth,
          day_of_birth
        )
      rescue ArgumentError
      end
    elsif day_of_birth.nil? && month_of_birth.nil? && year_of_birth.nil?
      params[:birth_date] = nil
    end
    params
  end

  def cast_to_number(value)
    value.present? ? value.to_i : nil
  end

  def validate_birth_date_is_real_date
    if day_of_birth.present? || month_of_birth.present? || year_of_birth.present?
      begin
        Date.new(
          year_of_birth,
          month_of_birth,
          day_of_birth
        )
      rescue StandardError
        errors.add(:birth_date, "is invalid")
      end
    end
  end

  def validate_user_is_valid
    unless user.valid?
      user.errors.each do |k,v|
        errors.add(k, v)
      end
    end
  end
end
