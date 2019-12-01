# frozen_string_literal: true

require "rails_helper"

describe JoinRequest, type: :model do
  it { should validate_inclusion_of(:status).in_array(%w[pending accepted]) }
end
