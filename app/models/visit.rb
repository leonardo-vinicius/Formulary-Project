class Visit < ApplicationRecord
  belongs_to :user
  has_many :formularies
  
end
