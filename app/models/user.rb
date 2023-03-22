require 'cpf_cnpj'
require 'GoodnessValidator'

class User < ApplicationRecord

    has_many :visits

    validates :password, length: {minimum:6, message: 'deve ter pelo menos 2 caracteres'},
        format: { with: /[0-9]/, on: :create}

    has_secure_password

    validates_presence_of :name
    validates_presence_of :email

    validates :name, presence: {message: 'não pode ser deixado em branco'},
        length: {minimum: 2, message: 'deve ter pelo menos 2 caracteres'}

    validates :email, presence: {message: 'n pode ficar vazio'},
        uniqueness: {message: 'deve ser unico'}, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create, message: 'Formato inválido' }

    validates :cpf, uniqueness: true, presence: true

    validates_with GoodnessValidator
    #validates_with CPF_Validator

end