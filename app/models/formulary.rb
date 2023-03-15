class Formulary < ApplicationRecord
  belongs_to :visit
  has_many :questions

  #validates :question.name, uniqueness: true
end
