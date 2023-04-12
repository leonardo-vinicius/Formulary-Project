FactoryBot.define do
    factory :visit do
        data{ "2024-03-16T13:06:45.868Z"}
        status{"REALIZADO"}
        checkin_at{"2023-03-16T13:06:45.868Z"}
        checkout_at{ "2023-03-17T13:07:45.868Z"}
        association :user 
    end

    factory :visit2, class: Visit do
        data{ "2023-12-01T13:06:45.868Z"}
        status{"PENDENTE"}
        checkin_at{"2023-04-07T13:06:45.868Z"}
        checkout_at{ "2023-04-09T13:07:45.868Z"}
        association :user 
    end

    factory :visit3, class: Visit do
        data{ "2024-01-20T13:06:45.868Z"}
        status{"PENDENTE"}
        checkin_at{"2023-02-10T13:14:00.868Z"}
        checkout_at{ "2023-02-11T13:12:00.868Z"}
        association :user 
    end
end