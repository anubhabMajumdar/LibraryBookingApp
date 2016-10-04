class Room < ApplicationRecord
  validates :room_id, presence: true, uniqueness: true
  has_many :booking
end
