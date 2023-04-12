class Formulary < ApplicationRecord
  belongs_to :visit
  has_many :questions

  # nome único
  validates :name, uniqueness: true, presence: true
end
