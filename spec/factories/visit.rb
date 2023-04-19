FactoryBot.define do
  factory :visit do
    data { Faker::Time.between(from:DateTime.now + 1, to:DateTime.now + 365) }
    status { ["REALIZADO", "PENDENTE", "CANCELADO"].sample }
    checkin_at { Faker::Time.between(from: DateTime.now - 365, to: DateTime.now - 1) }
    checkout_at { Faker::Time.between(from: checkin_at + 1, to: DateTime.now) }
    association :user 
  end
end