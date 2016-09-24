class Room < ApplicationRecord
  validates :room_id, presence: true

  has_many :booking
end
