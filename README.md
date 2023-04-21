# Formulary Project 
    Projeto de criação de uma API básica em Ruby on Rails. O projeto simula o fluxo de um sistema de coleta em campo.
    É basicamente uma API sobre um formulário que recebe uma autenticação base feito com o auxilio da gem JWT. No 
    projeto temos a criação do formulário em si cujo possui perguntas e respostas, o formulário é acessado por meio
    de uma visita do usuário em questão que fez a autenticação, seja ela permitida caso seja validada.
<lu>
Versões utilizadas:
<li> Ruby version 3.0.2
<li> Rails version 7.0.4.2
</lu>

<h2>Sobre os Models e Testes:</h2>
    Os models possuem as operações básicas Create, Read, Update e Delete

    User
    foi usada uma gem 'cpf_cnpj' e um código "CPFValidator" para validação do cpf
    e os demais com o comando validate
    caminho para testes: rspec ./spec/controllers/users_controller_spec.rb

    Visit
    usados comandos validate e foi criada uma função no controller que faz a checagem
    das datas de checkin e checkout se estão na lógica correta.
    caminho para testes: rspec ./spec/controllers/visits_controller_spec.rb

    Formulary
    usados comandos validate e uma checagem no controller acessando todos os formularios
    para fazer checagem de nomes repetidos e evitar que isso ocorra.
    caminho para testes: rspec ./spec/controllers/formularies_controller_spec.rb

    Question
    usados comandos validate
    caminho para testes: rspec ./spec/controllers/questions_controller_spec.rb

    Answer
    usados comandos validate
    caminho para testes: rspec ./spec/controllers/answers_controller_spec.rb

<lu>
    <h3>Fluxo Heroku:</h3>
    
    - ordem de criação - user, visit, formulary, question, answer
    (por exemplo visit precisa de um user_id e assim por diante)

    - Criar um Usuário: POST https://formularyapp.herokuapp.com/users
    - Fazer o login:    POST https://formularyapp.herokuapp.com/authenticate

    - após fazer o login colocar o auth_token gerado no header com a key: Authorization e value Bearer + auth_token

    - Fazer as demais operações GET/POST/PATCH/DELETE https://formularyapp.herokuapp.com/<model>
    Esse <model> pode ser: users, visits, formularies, questions, answers

    - se necessario o id: https://formularyapp.herokuapp.com/<model>/id
 </lu>