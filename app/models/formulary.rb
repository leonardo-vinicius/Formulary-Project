class Formulary < ApplicationRecord
  belongs_to :visit
  has_many :questions
  validates :name, uniqueness: true, presence: true
end
