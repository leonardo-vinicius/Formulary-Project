FactoryBot.define do
  factory :answer do
    sequence(:content) {|n|"Answer#{n}"}
    association :formulary
    association :question
    association :visit
  end
end