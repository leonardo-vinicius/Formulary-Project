class Visit < ApplicationRecord
  belongs_to :user 
  validates_presence_of :data, :checkin_at, :checkout_at, :status
end
