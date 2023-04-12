FactoryBot.define do
    factory :user do
        name { "Ramon"}
        email { "ramon@email.com"}
        password {"senha123"}
        #password_digest { 'senha123'}
        #password_confirmation {'senha123'}
        cpf { "64442017050" }
    end

    factory :user2, class: User do
        name { "Leonardo" }
        email { "leo590@gmail.com" }
        password { "leo12345" }
        cpf { "77807421053" }
    end
      
      factory :user3, class: User do
        name { "Nalanda" }
        email { "nalanda@hotmail.com" }
        password { "nalanda123" }
        cpf { "91013283015" }
    end
end

# usar o teste assim: create(:user)
# ou FactoryBot.create(:user)