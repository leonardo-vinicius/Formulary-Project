class Answer < ApplicationRecord
  belongs_to :formulary
  belongs_to :question
  belongs_to :visit

  validates_presence_of :content
end
