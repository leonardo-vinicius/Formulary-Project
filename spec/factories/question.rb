#Question( name: string, tipo_pergunta: string, formulary_id: integer)
FactoryBot.define do
    factory :question do
        name {"Pergunta 1"}
        tipo_pergunta {"texto"}
        association :formulary
    end

    factory :question2, class: Question do
        name {"Pergunta 2"}
        tipo_pergunta {"imagem"}
        association :formulary
    end

    factory :question3, class: Question do
        name {"Pergunta 3"}
        tipo_pergunta {"texto"}
        association :formulary
    end
end