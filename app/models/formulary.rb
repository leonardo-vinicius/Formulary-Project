class Formulary < ApplicationRecord
    has_many :questions
    belongs_to :visit
    # validates :[question_id].name, uniqueness: true

end