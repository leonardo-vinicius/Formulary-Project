class Formulary < ApplicationRecord
  belongs_to :visit
  has_many :questions
end
