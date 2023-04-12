FactoryBot.define do
    # Answer(content: string, answered_at: string, formulary_id: integer, question_id: integer, visit_id: integer)
    factory :answer do
        content {"Resposta da pergunta 1"}
        association :formulary
        association :question
        association :visit
    end

    factory :answer2, class: Answer do
        content {"Resposta da pergunta 2"}
        association :formulary
        association :question
        association :visit
    end

    factory :answer3, class: Answer do
        content {"Resposta da pergunta 3"}
        association :formulary
        association :question
        association :visit
    end
end