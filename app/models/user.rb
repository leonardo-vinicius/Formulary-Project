require 'cpf_cnpj'
require 'GoodnessValidator'

class User < ApplicationRecord

    # testando mudança de branch 8888

    has_secure_password

    has_many :visits # associação com visitas

    validates_presence_of :name
    validates_presence_of :email
    #validates_presence_of :password
    #validates_presence_of :password_confirmation

    validates :name, presence: {message: 'não pode ser deixado em branco'},
        length: {minimum: 2, message: 'deve ter pelo menos 2 caracteres'}

    validates :email, presence: {message: 'n pode ficar vazio'},
        uniqueness: {message: 'deve ser unico'}, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

   # validates :password, presence: {message: 'não pode ser deixado em branco'},
    #    length: {minimum: 6, message: 'deve ter pelo menos 6 caracteres'}
    
    validates :cpf, uniqueness: true, presence: true

    validates_with GoodnessValidator

end