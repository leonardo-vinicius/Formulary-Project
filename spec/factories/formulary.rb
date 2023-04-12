#Formulary(id: integer, name: string, visit_id: integer, created_at: datetime, updated_at: datetime)

FactoryBot.define do
    factory :formulary do
        name { "Formulario 1" }
        association :visit 
    end

    factory :formulary2, class: Formulary do
        name { "Formulario 2" }
        association :visit 
    end

    factory :formulary3, class:  Formulary do
        name { "Formulario 3" }
        association :visit 
    end
end