require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_most(250) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:date) }
end
