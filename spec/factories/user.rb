Faker::Config.locale = :pt

FactoryBot.define do
  factory :user do
    sequence(:name) { Faker::Name.name }
    sequence(:email) { Faker::Internet.email }
    password { "#Password123" }
    sequence(:cpf) { Faker::IDNumber.brazilian_citizen_number }
  end
end