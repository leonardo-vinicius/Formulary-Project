require 'CPFValidator'

class User < ApplicationRecord
  has_many :visits
  has_secure_password
  validates_with CPFValidator
        
  PASSWORD_FORMAT_ERROR_MESSAGE = 'password is invalid, it must contain at least one number'.freeze

  validates :password, format: { with:/\A*\d/i, message: PASSWORD_FORMAT_ERROR_MESSAGE }
  validates :cpf, uniqueness: true, presence: true
  validates :email, uniqueness: :true, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end