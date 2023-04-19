FactoryBot.define do
  factory :formulary do
    sequence(:name) { |n| "Formulary#{n}" }
    association :visit
  end
end