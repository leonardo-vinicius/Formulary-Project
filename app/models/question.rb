class Question < ApplicationRecord
  belongs_to :formulary
  has_one :answer
  validates_presence_of :name, :tipo_pergunta
end
