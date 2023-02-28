class Question < ApplicationRecord
  belongs_to :formulary, optional: true # checa esse opcional depois
end
