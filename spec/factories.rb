FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    name { "John Doe" }
    email
    password { "password" }
  end

  factory :post do
    game { "Football" }
    game_type { "sport" }
    players_needed { 2 }
    description { "Test post" }
    city { "Belgrade" }
    date { Date.today }
    association :user, factory: :user
  end

  factory :notification do
    association :recipient, factory: :user
    association :actor, factory: :user
    text { "Test notification" }
    action_path { "/" }
  end
end
