FactoryBot.define do
  factory :question do
    sequence(:name) { |n|"Question#{n}" }
    tipo_pergunta {["texto", "imagem"].sample}
    association :formulary
  end
end